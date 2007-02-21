Return-Path: <linux-kernel-owner+w=401wt.eu-S1422762AbXBUSUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbXBUSUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBUSUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:20:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41897 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762AbXBUSUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:20:52 -0500
Message-ID: <45DC8DA1.6030100@cs.helsinki.fi>
Date: Wed, 21 Feb 2007 20:21:21 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Well could you check ksize for the old object first and if ksize <= new 
> size then just skip the copy? I think this may allow you 
> to get rid of the ksize callers.

And not reallocate at all, right? I thought about that but then you 
wouldn't be able to use realloc() to make the buffer smaller.

			Pekka

