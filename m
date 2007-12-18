Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXLRFTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXLRFTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763009AbXLRFSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:18:53 -0500
Received: from ozlabs.org ([203.10.76.45]:60021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761128AbXLRFSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:18:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 13/21] [PATCH] change bitwise operations to get a void parameter.
Date: Tue, 18 Dec 2007 16:18:42 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
References: <11979319641796-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com>
In-Reply-To: <11979320302030-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181618.43852.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 09:52:36 Glauber de Oliveira Costa wrote:
> This patch changes the bitwise operations in bitops.h to get
> a void pointers as a parameter. Before this patch, a lot of warnings
> can be seen. They're gone after it.

No, this is a backwards step!  These warnings are important for 
non-arch-specific code: I fought hard to get them made into unsigned longs.

But I'm happy for this to be applied as is, then I'll grab the git tree, 
revert it and fix the warnings...

Rusty.
