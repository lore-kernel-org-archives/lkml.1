Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYEDSEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYEDSEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYEDSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:04:37 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:53053 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYEDSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=xMv0HDImFaLcBFQWJuKBYMS5oKbc8NSO2/bRFe/pf1CQzXUXc09hRJlHksbRawXwZz8TLZbXc32jX1pdbUR5p3xMHoCm1/FABnIPfuQYjjRI7cwOC7cx3kQ2svEflT6yFtqCJeDL5JkT0BE0aej6vmYxMnYwrJgeYGGBnicNicQ=
Date: Sun, 4 May 2008 13:04:27 -0500
From: Josh Boyer <jwboyer@gmail.com>
To: =?ISO-8859-1?B?SvZybg==?= Engel <joern@logfs.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       matthieu castet <castet.matthieu@free.fr>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, linux-mtd@lists.infradead.org
Subject: Re: LogFS merge
Message-ID: <20080504130427.583d563c@vader.jdub.homelinux.org>
In-Reply-To: <alpine.LFD.1.10.0805041809370.3318@apollo.tec.linutronix.de>
References: <481C3087.8020501@free.fr>
	<20080503120005.GA32608@logfs.org>
	<alpine.LFD.1.10.0805041809370.3318@apollo.tec.linutronix.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 18:20:23 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > Logfs ignores ubi and does wear leveling, bad block handling, etc.
> > itself.  Bad block handling in particular is not too robust yet.  If you
> > expect blocks to rot away after mkfs time, logfs is a bad choice.
> 
> It's a matter of fact that especially on NAND flash blocks become bad
> over time, i.e. after mkfs. So that's a pretty crucial feature which
> needs to be complete and robust before it's declared to be usable on
> such devices.

I agree.  LogFS seems quite impressive in its performance, however I'm
wondering how much redesign and rewrite would be needed in the code to
fix the bad block handling.  Maybe it's not so much and I'm overly
paranoid, but having at least some idea of what it would take might
help.  You could add it to Documentation/filesystems/LogFS.txt as a
TODO.

josh
