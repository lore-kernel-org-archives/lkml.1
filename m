Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZKVM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZKVM6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZKVM6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:58:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:43680 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZKVM6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MwPB5wDzKJbDYWDlKJAvuVJ6m0rEAy4npnDwRFx4NkaCi85tJHX+dF6iiuoyae/waK
         UgD3i+jObQqOyu4i2WEqtBU5mkK/q4iLDPuIZepw/Faq6GCSALkdw1l6FqmUsJTOGdWD
         WsNVDB+FrIIRekuMC7Qndr8ILito5jPSwCB84=
Subject: Re: XD/smartmedia - how to implement it right?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091121102542.GA21136@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Nov 2009 14:58:33 +0200
Message-ID: <1258894713.4127.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 11:25 +0100, Jörn Engel wrote: 
> On Sat, 21 November 2009 02:25:44 +0200, Maxim Levitsky wrote:
> > 
> > This thread is meant to continue discussion about XD/smartmedia support
> > in linux.
> > 
> > I CC'd few peoples that participated in original discussion.
> > 
> > Alex Dubov attempted to write a driver for jmicron device (I have it
> > btw), but this was rejected due to code duplication.
> > 
> > I successfully reverse engineered (in my free time) the XD card reader
> > found on my laptop (ricoh based one)
> > 
> > I would like to know how you think to implement the subsystem support
> > right.
> > 
> > I would go with mmc subsystem + FTL, but according to original thread,
> > there are numerous problems with this approach.
> > 
> > Any advice is appreciated.
> 
> A novel approach might be to just send the code as a patch.  Last time
> around noone seemed to have had a real look.
> 
> The "mtd uses blocking calls" argument I can help with.  For some other
> project I've added non-blocking calls to mtd[1].
> 
> Biggest problems I see are a) the userspace interface and b) allowing
> both raw flash access through MTD and block device access with an FTL.
> 
> [1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html
> 
> Jörn


I don't have much to say right now, I will study the sources for a
while, and then continue the effort.


Best regards,
Maxim Levitsky

