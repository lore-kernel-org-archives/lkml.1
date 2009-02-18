Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZBRUzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZBRUzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZBRUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:55:21 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:27442 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZBRUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:55:20 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
Date: Wed, 18 Feb 2009 15:55:14 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <499C40C1.20106@schaufler-ca.com> <499C62E4.1030600@numericable.fr>
In-Reply-To: <499C62E4.1030600@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181555.14738.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 02:35:00 pm etienne wrote:
> Casey Schaufler wrote:
> > Yes, it would make it nicer. You'll need to do a better job
> > on the list management than I've been doing. It's probably well
> > past time to introduce the Standard list management scheme to
> > Smack, and you'll need to do so if you want to do insertions
> > and/or deletions.
>
> well, we could maybe do that for smack_netlbladdrs.
> for smk_rules, i don't know, depending to the use case, it could grow
> bigger and thus need a more efficient scheme than linked-list like
> hash-table.

The code is easily changed because it is private to Smack and we don't have to 
worry about backwards compatibility issues.  I would focus on improving the 
linked list approach (masked, sorted, etc.) and when traversing the list 
becomes a bottleneck we can look at alternative approaches.  Others may have a 
better view, but from what I've seen the general approach taken in Linux 
Kernel optimization is to develop something that works then refine and 
optimize it once you have a better understanding of the common use cases.  

-- 
paul moore
linux @ hp

