Return-Path: <linux-kernel-owner+w=401wt.eu-S966611AbXJSD7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966611AbXJSD7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966535AbXJSD7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:59:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54909 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966312AbXJSD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:58:57 -0400
Date: Thu, 18 Oct 2007 20:56:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/5] Use wake_up_locked() in eventpoll
Message-ID: <20071018205623.717ef237@laptopd505.fenrus.org>
In-Reply-To: <11927463621072-git-send-email-matthew@wil.cx>
References: <11927463623428-git-send-email-matthew@wil.cx>
	<11927463621072-git-send-email-matthew@wil.cx>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 18:25:58 -0400
Matthew Wilcox <matthew@wil.cx> wrote:

Have you tested this patch with LOCKDEP enabled? eventpoll is... tricky
in what it does with waitqueues and locks.... and some of this stuff is
there, afaik, to deal with that. You're now changing this ... call me
chicken :)
