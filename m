Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZFHLPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZFHLPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZFHLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:15:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZFHLPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:15:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [Bug #13473] Bug while trying to launch a KVM guest
Date: Mon, 8 Jun 2009 13:16:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mimi Zohar <zohar@us.ibm.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.V6F.5Y7KKB@chimera> <4A2C92EB.5020002@in.ibm.com>
In-Reply-To: <4A2C92EB.5020002@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081316.12250.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, Sachin Sant wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13473
> > Subject		: Bug while trying to launch a KVM guest
> > Submitter	: Sachin Sant <sachinp@in.ibm.com>
> > Date		: 2009-06-05 17:20 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124422173129047&w=4
> > Handled-By	: Mimi Zohar <zohar@us.ibm.com>
> >   
> This problem is fixed by the following patches.
> 
> f06dd16a03f6f7f72fab4db03be36e28c28c6fd6 : IMA: Handle dentry_open failures
> 1a62e958fa4aaeeb752311b4f5e16b2a86737b23 : IMA: open all files O_LARGEFILE
> 
> I can't really say this is a regression. I never had compiled a kernel with
> CONFIG_IMA until 2.6.30-rc8. 

I see.  Perhaps I'll drop it from the list and mark it as resolved, then.

Best,
Rafael
