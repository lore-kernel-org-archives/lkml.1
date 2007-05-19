Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbXESMxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbXESMxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESMxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:53:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:52451 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbXESMxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:53:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RimG8OJxacs7E/d+mvMuTNqDbfq1BandFO/UAqZUWUly8rmWy+FyaDHM7IjLMcJzu3djddKtKGCo3A3xxaL759ob06utu+akMvgHDsKCb3djRxCdjH4IH+xD7pRDv26rtLOV4sX1Iz9TVhx5Mbx3VDogqqoVohcvV55EU9mo0So=
Message-ID: <84144f020705190553s598e722fu7279253ee8b516bc@mail.gmail.com>
Date: Sat, 19 May 2007 15:53:04 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 01/10] SLUB: add support for kmem_cache_ops
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <20070518181118.828853654@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518181040.465335396@sgi.com>
	 <20070518181118.828853654@sgi.com>
X-Google-Sender-Auth: 208e16f59a434944
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> kmem_cache_ops is created as empty. Later patches populate kmem_cache_ops.

Hmm, would make more sense to me to move "ctor" in kmem_cache_ops in
this patch and not make kmem_cache_create() take both as parameters...
