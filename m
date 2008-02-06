Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYBFWKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYBFWKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbYBFWKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:10:22 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48632 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759394AbYBFWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:10:20 -0500
Date: Wed, 6 Feb 2008 14:10:18 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: statistics improvements
In-Reply-To: <47AA2955.50502@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802061409420.3712@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0802042217460.6801@schroedinger.engr.sgi.com>
 <20080206001948.6f749aa8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802061259490.26108@schroedinger.engr.sgi.com>
 <47AA2955.50502@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Eric Dumazet wrote:

> > +	for_each_online_cpu(cpu) {
> > +		int x = get_cpu_slab(s, cpu)->stat[si];
> 
> unsigned int x = ...

Ahh. Thanks.

