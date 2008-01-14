Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYANSZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYANSZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYANSZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:25:33 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYANSZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:25:32 -0500
Date: Mon, 14 Jan 2008 19:25:31 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: travis@sgi.com
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] x86: Change NR_CPUS arrays in topology
In-Reply-To: <20080113183454.815670000@sgi.com>
Message-ID: <Pine.LNX.4.64.0801141925070.24893@fbirervta.pbzchgretzou.qr>
References: <20080113183453.973425000@sgi.com> <20080113183454.815670000@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13 2008 10:34, travis@sgi.com wrote:
>+++ b/include/asm-x86/cpu.h
>@@ -7,7 +7,7 @@
> #include <linux/nodemask.h>
> #include <linux/percpu.h>
> 
>-struct i386_cpu {
>+struct x86_cpu {
> 	struct cpu cpu;
> };
> extern int arch_register_cpu(int num);

Is not struct x86_cpu kinda redundant here if it only wraps around
one member?
