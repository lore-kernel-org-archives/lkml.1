Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZKAHHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZKAHHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 02:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZKAHHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 02:07:47 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:60565 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZKAHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 02:07:46 -0500
Date: Sun, 1 Nov 2009 08:09:00 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>
Subject: Re: [PATCH] serial 8250: fixes for Alchemy uarts.
Message-ID: <20091101070900.GB4551@linux-mips.org>
References: <1256762248-4305-1-git-send-email-manuel.lauss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256762248-4305-1-git-send-email-manuel.lauss@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 09:37:28PM +0100, Manuel Lauss wrote:

> Limit the amount of address space claimed for Alchemy serial ports
> to 0x1000.  On the Au1300, ports are only 0x1000 apart, and the
> registers only extend to 0x110 at most on all supported alchemy models.
> 
> On the Au1300 the autodetect logic no longer works and this makes
> it necessary to specify the port type through platform data.  Because
> of this the MSR quirk needs to be moved outside the autoconfig()
> function which will no longer be called when UPF_FIXED_TYPE is
> specified.

Andrew,

looks sane to me.  Since this is a MIPS patch I'd like to funnel it through
the MIPS tree.  Ok?

  Ralf
