Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYDVUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYDVUDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYDVUC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:02:59 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:7018 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755034AbYDVUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DnOK8H3MgVzrUXJjypY1DG5TqLlg63hO46qCGQQA7ULapT0mBy/Q80TZvkZTRDrKPhEYlcqpBS4g7L21sJwDt2x8Z5/k7048wtmEGx+jb3mZzLsASIKW/xuG0CTGyRAizbkM4zeZU3gChEBYNQHkoMYuIp5oxNKbd9ZzCVOmZjs=
Subject: Re: pasic3 allmod/yesconfig build error
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>, linux-kernel@vger.kernel.org,
       philipp.zabel@gmail.com
In-Reply-To: <20080422194933.GB9911@flint.arm.linux.org.uk>
References: <28221442.1208881240429.JavaMail.oracle@acsmt302.oracle.com>
	 <20080422194933.GB9911@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 13:03:21 -0700
Message-Id: <1208894601.24124.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 20:49 +0100, Russell King - ARM Linux wrote:
> On Tue, Apr 22, 2008 at 11:20:40AM -0500, Randy Dunlap wrote:
> > allmodconfig and allyesconfig on $ARCH try to build the htc-pasic3 driver,
> > but it fails due to wanting <asm/arch/pxa-regs.h>.
> > 
> > Should the Kconfig file be modified to build this driver only for $ARCH=arm ?
> 
> Known problem.  You're about the 4th person in the last 24 hours to
> report this.
> 
> It's been known about since Sunday.  Unfortunately, Linus not responding
> to emails until midnight (my time) on Monday meant that I've not been able
> to do anything about it, despite having a fix (along with others) already
> merged but not properly queued up (because I didn't know what Linus was
> going to do.)
> 
> So... I'm not going to be able to properly sort my tree until Thursday.
> Please ignore it until Friday.  Thanks.

People make mistakes, it happens.  For people who have hit this, do you
have a tree they can pull from to get the fixes?

> 
> (Please note that these reports are stressing me because I have the fix,
> I've known about it for ages, but because of factors out of my control -
> and community policy, in so far as "you do not change the tree you've asked
> to be pulled from" I'd have been unable to resolve it and all the other
> stupid breakage in that pull before anyone saw it.  I suppose what I
> should've done was deleted the tree of kernel.org so Linus _couldn't_
> pull it.)

Couldn't you just send Linus another pull request with further fixes?

Harvey

