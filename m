Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYIKTjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYIKTjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYIKTjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:39:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55772 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYIKTjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:39:15 -0400
Message-ID: <48C97310.9060507@cs.helsinki.fi>
Date: Thu, 11 Sep 2008 22:35:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Salman Qazi <sqazi@google.com>
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org
Subject: Re: slub: fixed uninitialized counter in struct kmem_cache_node
References: <20080911192541.GA23822@google.com>
In-Reply-To: <20080911192541.GA23822@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salman Qazi wrote:
> Initialized total objects atomic for the node in init_kmem_cache_node.  The uninitialized value was ruining the stats in /proc/slabinfo.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Applied, thanks!
