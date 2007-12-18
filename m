Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbXLRFuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbXLRFuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXLRFuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:50:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbXLRFuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:50:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
Subject: Re: [PATCH 3/21] [PATCH] move desc_empty to where they belong
In-Reply-To: Roland McGrath's message of  Monday, 17 December 2007 21:35:08 -0800 <20071218053508.BB73526F98A@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <11979319641796-git-send-email-gcosta@redhat.com>
	<11979319763641-git-send-email-gcosta@redhat.com>
	<11979319811234-git-send-email-gcosta@redhat.com>
	<200712181614.37890.rusty@rustcorp.com.au>
	<20071218053508.BB73526F98A@magilla.localdomain>
Emacs: an inspiring example of form following function... to Hell.
Message-Id: <20071218055007.9C96926F98A@magilla.localdomain>
Date: Mon, 17 Dec 2007 21:50:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll have a TLS cleanup patch soon that makes the (only) use of desc_empty
> pass a struct user_desc pointer.

Oops, I meant struct desc_struct of course.  But in fact the only use is
already using the right struct pointer, so we can clean up desc_empty now
(in x86/mm).


Thanks,
Roland
