Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYLAHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYLAHOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYLAHOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:14:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:41888 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYLAHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H+iohdexq84eApzZVy9Fu43T80R7mfrFv6Np+PdRQmn14Z1FZE1ObO8ddKLt9HUUGn
         I59sqBTjSdV+aOhPBv79tJv1qkopmRIGypvDf7rsT0YvTtx6aCrc3ukSB2N4G5IFd6zQ
         FWfp16fs0RG3ezilzHUOxIZRt7zkCDTUv6AS4=
Subject: Re: [PATCH-mm 4/7] sh: wire up arch overrides for unaligned access
 on the SH4a
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20081201065123.GB30438@linux-sh.org>
References: <1228012830.26141.1029.camel@brick>
	 <20081201065123.GB30438@linux-sh.org>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 23:14:17 -0800
Message-Id: <1228115658.5482.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 15:51 +0900, Paul Mundt wrote:
> On Sat, Nov 29, 2008 at 06:40:30PM -0800, Harvey Harrison wrote:
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  arch/sh/include/asm/unaligned-sh4a.h |  258 ----------------------------------
> >  arch/sh/include/asm/unaligned.h      |   76 ++++++++--
> >  2 files changed, 61 insertions(+), 273 deletions(-)
> > 
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> 
> Thanks for looking at this!

No worries, I've also CC'd the AVR32 maintainer as I think his arch
could do something similar as that arch also provides limited
unaligned access that might be worth adding an override for.

Cheers,

Harvey

