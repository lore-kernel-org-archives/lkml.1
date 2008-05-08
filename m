Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbYEHWvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbYEHWvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762546AbYEHWuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:50:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762266AbYEHWuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:50:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 02/18] flag parameters: paccept
In-Reply-To: Andrew Morton's message of  Thursday, 8 May 2008 15:38:22 -0700 <20080508153822.0c4dd6e9.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <200805062118.m46LI7SS004041@devserv.devel.redhat.com>
	<20080508153822.0c4dd6e9.akpm@linux-foundation.org>
X-Windows: flaky and built to stay that way.
Message-Id: <20080508225043.0A84026FA85@magilla.localdomain>
Date: Thu,  8 May 2008 15:50:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some architectures (including x86) do not implement TIF_RESTORE_SIGMASK.

It's now spelled:

       set_restore_sigmask();

For the other syscalls that depend on this (e.g. sys_ppoll),
we just put the whole definition in #ifdef HAVE_SET_RESTORE_SIGMASK.

The few machines that don't have RESTORE_SIGMASK support of some flavor,
also have not assigned numbers to the syscalls that need it.


Thanks,
Roland
