Return-Path: <linux-kernel-owner+w=401wt.eu-S937826AbXG1Cjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937826AbXG1Cjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbXG1Cjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:39:39 -0400
Received: from ozlabs.org ([203.10.76.45]:52557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992AbXG1Cji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:39:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18090.33898.360087.492895@cargo.ozlabs.ibm.com>
Date: Sat, 28 Jul 2007 09:48:58 +1000
From: Paul Mackerras <paulus@samba.org>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/68] 0 -> NULL, for arch/powerpc
In-Reply-To: <200707270945.LAA17267@ifs.emn.fr>
References: <200707270945.LAA17267@ifs.emn.fr>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau writes:

> When comparing a pointer, it's clearer to compare it to NULL than to 0.

As other people have said, if you're going to spend time on this,
testing (!buf) is more idiomatic in the kernel than (buf == NULL).

Paul.
