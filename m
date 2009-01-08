Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZAHTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZAHTgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZAHTgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:36:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZAHTgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:36:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: Oleg Nesterov's message of  Thursday, 8 January 2009 15:32:20 +0100 <20090108143220.GA8717@redhat.com>
References: <49639EB8.40204@redhat.com>
	<4963ABF0.6070400@redhat.com>
	<20090107123457.GB16268@elte.hu>
	<20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	<a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
	<20090108143220.GA8717@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090108193530.99D74FC3DD@magilla.sf.frob.com>
Date: Thu,  8 Jan 2009 11:35:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since waitfd shouldn't consume the child termination notification
> > waitfd should be more widely usable than the wait*() interfaces.

waitid can be used that way with WNOWAIT.
