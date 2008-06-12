Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbYF0Uvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbYF0Uvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYF0UuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYF0UuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Thorsten Knabe <linux@thorsten-knabe.de>, Jeff Dike <jdike@addtoit.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
In-Reply-To: WANG Cong's message of  Sunday, 8 June 2008 22:34:34 +0800 <20080608143434.GF2487@hacking>
References: <483EC624.90503@thorsten-knabe.de>
	<20080601213134.GJ4018@sequoia.sous-sol.org>
	<20080602010546.GA8578@c2.user-mode-linux.org>
	<484719C7.2020502@thorsten-knabe.de>
	<20080605004925.GA15461@c2.user-mode-linux.org>
	<484BC4DF.5000605@thorsten-knabe.de>
	<20080608143434.GF2487@hacking>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20080627204954.576B215423B@magilla.localdomain>
Date: Thu, 12 Jun 2008 11:58:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, mea culpa.  I added the bug in commit
5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b.
It's already gone for 2.6.26 with the compat_arch_ptrace cleanup.

-stable patch to follow.


Thanks,
Roland
