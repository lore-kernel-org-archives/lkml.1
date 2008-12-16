Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYLPTP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYLPTP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYLPTPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:15:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbYLPTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:15:37 -0500
Date: Tue, 16 Dec 2008 11:14:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate
 related
In-Reply-To: <20081216190707.GA336@elte.hu>
Message-ID: <alpine.LFD.2.00.0812161113350.14014@localhost.localdomain>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.bnH.14_QJB@chimera> <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com> <200812131956.03495.rjw@sisk.pl> <20081216190707.GA336@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Dec 2008, Ingo Molnar wrote:
> 
> yeah - i think it's too late to do anything but a revert here.

Yup. Already done. Commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325.

Did -stable revert it too?

			Linus
