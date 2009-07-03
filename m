Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZGCMUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZGCMUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZGCMUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:20:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53450 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZGCMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:20:00 -0400
Subject: Re: [PATCH] kmemleak: Trace the kmalloc_large* functions in slub
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090703121825.18771.79975.stgit@pc1117.cambridge.arm.com>
References: <20090703121825.18771.79975.stgit@pc1117.cambridge.arm.com>
Date: Fri, 03 Jul 2009 15:20:01 +0300
Message-Id: <1246623601.4807.17.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 13:18 +0100, Catalin Marinas wrote:
> The kmalloc_large() and kmalloc_large_node() functions were missed when
> adding the kmemleak hooks to the slub allocator. However, they should be
> traced to avoid false positives.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

