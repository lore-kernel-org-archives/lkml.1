Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbYD2VDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbYD2VDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYD2VC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:02:57 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:57652 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYD2VC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i9GcI8Wf9V1IvkEYLnjjHrd6ImFbT08UpyHDlVbOL85XF8u2w/YeCOBdtrKXE/yeTIKrH27iXG5dFAiLUZeXAwaERydo1FGg5r6ysAUkHq9unkGZZy4iYgdhAC9nAYk4NgCb2ZYvFCSwNywDWmHnybpYhAwd1CoPdfCkT1JbMNA=
Subject: Re: pcmcia_ioctl.c compile error
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Adrian Bunk <bunk@kernel.org>,
       "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080429135902.504b6362.rdunlap@xenotime.net>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	 <20080429201704.GA31311@flint.arm.linux.org.uk>
	 <20080429135902.504b6362.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 14:03:07 -0700
Message-Id: <1209502988.24729.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-29 at 13:59 -0700, Randy Dunlap wrote:
> On Tue, 29 Apr 2008 21:17:04 +0100 Russell King wrote:
> 
> > On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> > > Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> > > came through -mm that contains a patch implementing the overdue removal 
> > > of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> > 
> > Okay, this means at least one of my platforms is now dead as far as
> > building new kernels for it, and nothing I can do about that.  Ho hum.
> 
> I don't get it.  Several of us had building problems for a few
> days with some pasic driver.  We posted some bug reports and
> some patches, but we put up with it for a few days...
> 

I believe Russell is referring to the removal of the ioctl, not the
compile breakage.

Harvey

