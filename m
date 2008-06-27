Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbYF0Uur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbYF0Uur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYF0UuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYF0UuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Joris van Rantwijk <jorispubl@xs4all.nl>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Thorsten Knabe <linux@thorsten-knabe.de>
Subject: Re: BUG: Linux 2.6.25 ptrace leaks struct_task
In-Reply-To: Jeff Dike's message of  Friday, 27 June 2008 16:00:50 -0400 <20080627200050.GA10859@c2.user-mode-linux.org>
References: <20080627183045.GA18801@xs4all.nl>
	<20080627200050.GA10859@c2.user-mode-linux.org>
X-Shopping-List: (1) Prenatal Travesty
   (2) Meretricious destroyer televisions
   (3) Instantaneous removers
   (4) Red-winged bracelets
   (5) Reddy-Mix Aesthetic gong bag lunches
Message-Id: <20080627204954.2A76C154219@magilla.localdomain>
Date: Fri, 27 Jun 2008 13:17:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, good diagnosis.  The culprit is
> 5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b.  Doing an s/return /ret = /
> inside that switch should fix the bug.

I could swear I posted this fix two weeks ago, but I can't find the posting
now.  I do still have it lurking in a GIT tree though.


Thanks,
Roland
