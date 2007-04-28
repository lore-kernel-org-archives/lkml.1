Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXD1Vzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXD1Vzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXD1Vzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:55:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38048 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbXD1VzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:55:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
References: <463382E5.9060701@goop.org>
Date: Sat, 28 Apr 2007 15:53:56 -0600
In-Reply-To: <463382E5.9060701@goop.org> (Jeremy Fitzhardinge's message of
	"Sat, 28 Apr 2007 10:22:45 -0700")
Message-ID: <m14pn0dv2j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> This adds an smp_ops for voyager, and hooks things up appropriately.
> This is the first baby-step to making subarch runtime switchable.


Unless I have missed something early_gdt_descr still needs to be updated. 

Eric
