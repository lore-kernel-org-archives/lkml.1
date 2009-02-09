Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZBIRMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZBIRMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZBIRMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:12:38 -0500
Received: from www.tglx.de ([62.245.132.106]:44173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZBIRMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:12:37 -0500
Date: Mon, 9 Feb 2009 18:12:24 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ben-linux@fluff.org,
       "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] User access to internal clocks
Message-ID: <20090209171224.GD3167@local>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 06:04:29PM +0100, Davide Rizzo wrote:
> To: Greg KH <gregkh@suse.de>
> Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
> ben-linux@fluff.org, linux-api@vger.kernel.org

Davide,
please remove me from CC:, I'm not one of the clock gurus (which you might
want to CC instead).

Thanks,
Hans


> 
> This driver is for user level programs to interact with system clocks.
> It allows to read and modify rates and parents, using virtual files.
> It requires the implementation of 2 additional functions in the clk interface:
>  clk_for_each() and clk_name().
> Actually I implemented that functions only for Samsung S3C24xx platform.
