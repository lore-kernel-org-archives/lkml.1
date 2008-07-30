Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbYG3OlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbYG3OlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYG3OlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:41:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYG3OlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:41:04 -0400
Message-ID: <48907D36.20505@linux-foundation.org>
Date: Wed, 30 Jul 2008 09:39:50 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       mhalcrow@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
References: <488DF00F.3080809@redhat.com>	 <20080728133504.156f438f.akpm@linux-foundation.org> <84144f020807281342t2e1a3dc3id01314ac01de406f@mail.gmail.com>
In-Reply-To: <84144f020807281342t2e1a3dc3id01314ac01de406f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:

> Hmm, SLUB will use the page allocator directly for PAGE_CACHE_SIZE
> regadless of whether debugging is enabled or not...

Only until 2.6.24. SLUB uses page allocator for > PAGE_CACHE_SIZE


