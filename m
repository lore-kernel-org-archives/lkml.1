Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYFIPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYFIPYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYFIPY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:24:26 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64543 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753410AbYFIPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:24:25 -0400
Date: Mon, 9 Jun 2008 16:23:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Glauber Costa <gcosta@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <1213021018-14159-12-git-send-email-gcosta@redhat.com>
Message-ID: <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Glauber Costa wrote:

> Do it, instead of keeping in io_apic_32.c. This is the way x86_64
> already does.

 This change looks wrong -- is native_smp_prepare_cpus() at all run on
!CONFIG_SMP?  I don't think so.  You have to do this differently.

  Maciej
