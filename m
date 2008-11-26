Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYKZKoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYKZKoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYKZKop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:44:45 -0500
Received: from ozlabs.org ([203.10.76.45]:43305 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYKZKoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:44:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18733.8024.91224.512595@cargo.ozlabs.ibm.com>
Date: Wed, 26 Nov 2008 21:05:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 00/24] perfmon: introduction
In-Reply-To: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
References: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eranian@googlemail.com writes:

> This new version, named perfmon3, uses only 5 system calls (instead of 12).
> Each call was carefully designed to allow for future extensions. 

I notice that the userspace stuff in CVS assumes perfmon3 has 7 system
calls, the 5 added here plus pfm_create_sets and pfm_getinfo_sets.
Are you planning to add those two later (in which case we should
reserve the numbers now), or are you going to implement the
functionality of those two in pfm_write and pfm_read?

Regards,
Paul.
