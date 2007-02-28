Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXB1HZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXB1HZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXB1HZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:25:29 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37596 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXB1HZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:25:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ak@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] affinity is not defined in non-smp kernels - i386
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<1172646816.29709.15.camel@sebastian.intellilink.co.jp>
Date: Wed, 28 Feb 2007 00:24:40 -0700
In-Reply-To: <1172646816.29709.15.camel@sebastian.intellilink.co.jp>
 (Fernando
	Luis =?iso-8859-1?Q?V=E1zquez?= Cao's message of "Wed, 28 Feb 2007 16:13:36
 +0900")
Message-ID: <m1wt22iw1z.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> writes:

> Initialize affinity only when building SMP kernels.

Reasonable.  I goofed here.

However I would prefer my patch that just deletes these problem lines.
These lines don't really contribute anything and are harmless to
remove.

Eric
