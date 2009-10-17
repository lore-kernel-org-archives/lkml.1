Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZJQIzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZJQIzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 04:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZJQIzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 04:55:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZJQIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 04:55:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Kf+UNy45SfRCMj+PZ3uL331HN6EEay7nuC881iHnydw3LZXSzuJTBiqGV6wOz+oWA
	t3Bp3MeVBA/JyJrY9kz5A==
Date: Sat, 17 Oct 2009 01:55:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.10.0910162126090.26081@gentwo.org>
Message-ID: <alpine.DEB.1.00.0910170154580.31277@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com> <alpine.DEB.1.10.0910162126090.26081@gentwo.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Christoph Lameter wrote:

> > No, it just clears that particular statistic.
> 
> Ahh. Yes I mis-scanned the loop there. Would it not be better to reset all
> counters using some trigger file? Its a bit difficult to reset them all
> with this patch.
> 

Pekka seems willing to look at a patch that moves all statistic files to 
/sys/kernel/slab/cache/stats, so it should make both collecting and now 
clearing stats very easy without the addition of another file.
