Return-Path: <linux-kernel-owner+w=401wt.eu-S933942AbYEHW7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbYEHW7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbYEHW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:58:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765761AbYEHW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:58:47 -0400
Date: Thu, 08 May 2008 15:58:41 -0700 (PDT)
Message-Id: <20080508.155841.88051498.davem@davemloft.net>
To: roland@redhat.com
Cc: akpm@linux-foundation.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, oleg@tv-sign.ru
Subject: Re: [PATCH 02/18] flag parameters: paccept
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080508225043.0A84026FA85@magilla.localdomain>
References: <200805062118.m46LI7SS004041@devserv.devel.redhat.com>
	<20080508153822.0c4dd6e9.akpm@linux-foundation.org>
	<20080508225043.0A84026FA85@magilla.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Thu,  8 May 2008 15:50:43 -0700 (PDT)

> It's now spelled:
> 
>        set_restore_sigmask();
> 
> For the other syscalls that depend on this (e.g. sys_ppoll),
> we just put the whole definition in #ifdef HAVE_SET_RESTORE_SIGMASK.
> 
> The few machines that don't have RESTORE_SIGMASK support of some flavor,
> also have not assigned numbers to the syscalls that need it.

I notice that this macro also sets the sigpending bit, although
some paths that end up calling set_restore_sigmask() already
do that.
