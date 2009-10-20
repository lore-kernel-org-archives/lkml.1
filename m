Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZJTAy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZJTAy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZJTAy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:54:26 -0400
Received: from ozlabs.org ([203.10.76.45]:36148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbZJTAy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:54:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/4] kmemleak: Scan the _ftrace_events section in modules
Date: Tue, 20 Oct 2009 11:24:18 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com> <20091019144928.14221.73541.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091019144928.14221.73541.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910201124.18695.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 01:19:29 am Catalin Marinas wrote:
> This section contains pointers to allocated objects and not scanning it
> leads to false positives.

Thanks, applied.  Want me to push this for 2.6.32?

Rusty.
