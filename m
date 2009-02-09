Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZBIRLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZBIRLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZBIRKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:10:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45701 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZBIRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:10:52 -0500
Date: Mon, 9 Feb 2009 17:10:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, ben-linux@fluff.org,
       "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] User access to internal clocks
Message-ID: <20090209171042.GA19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 06:04:29PM +0100, Davide Rizzo wrote:
> To: Greg KH <gregkh@suse.de>
> Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
> ben-linux@fluff.org, linux-api@vger.kernel.org
> 
> This driver is for user level programs to interact with system clocks.
> It allows to read and modify rates and parents, using virtual files.
> It requires the implementation of 2 additional functions in the clk interface:
>  clk_for_each() and clk_name().
> Actually I implemented that functions only for Samsung S3C24xx platform.

NAK.

> +       name = clk_get_name(clk);

This implies that there is a 1:1 relationship between a 'name' and a
struct clk.  No such thing exists (and where it does, it's being
eliminated in ARM because it's just plain and simple WRONG.)
