Return-Path: <linux-kernel-owner+w=401wt.eu-S1031398AbXDJS2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031398AbXDJS2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031399AbXDJS2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:28:08 -0400
Received: from mail.suse.de ([195.135.220.2]:33551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031398AbXDJS2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:28:07 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Clean up x86 control register and MSR macros (corrected)
Date: Tue, 10 Apr 2007 20:00:23 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200704101736.l3AHaiUv027830@tazenda.hos.anvin.org>
In-Reply-To: <200704101736.l3AHaiUv027830@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102000.23789.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007 19:36:44 H. Peter Anvin wrote:
> This patch is based on Rusty's recent cleanup of the EFLAGS-related
> macros; it extends the same kind of cleanup to control registers and
> MSRs.

Applied. Although it was somewhat painful because there were other
changes in the tree you diffed against.
 
> It also unifies these between i386 and x86-64; at least with regards
> to MSRs, the two had definitely gotten out of sync.

Intentionally, x86-64 doesn't care about 32bit only CPUs.

-Andi
