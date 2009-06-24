Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZFXSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZFXSnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760190AbZFXSnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:43:01 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47927 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760672AbZFXSm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bMs6jICWFhKBJprYQdwCW1/GvzlgX0P9cClgjCUmIvBGE876Y/jEXjyvt+AGHdP6TC
         AjMVnorJBpSCXZ5F5bqEflUxIvFTMgV0eXgJ5w3U+lSZGb/pZHEmh/y848+Xwh843nXe
         HWWs1Qfmq88xpXDgzR0Zp2qQP6GtKjVPoj/Yc=
MIME-Version: 1.0
In-Reply-To: <20090624113037.7d72ed59.akpm@linux-foundation.org>
References: <20090624080753.4f677847@infradead.org>
	 <20090624094622.d0b0fd82.akpm@linux-foundation.org>
	 <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com>
	 <20090624105517.904f93da.akpm@linux-foundation.org>
	 <4A426825.80905@cs.helsinki.fi>
	 <20090624113037.7d72ed59.akpm@linux-foundation.org>
Date: Wed, 24 Jun 2009 21:43:01 +0300
X-Google-Sender-Auth: a82d286030e8c389
Message-ID: <84144f020906241143w76f57031u1cc185bd81d6caf7@mail.gmail.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, cl@linux-foundation.org, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 9:30 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> What's the expected value of s->min in allocate_slab()?  In what
> situations would it be >0?

When object size in the cache doesn't fit on a single page. See the
get_order() at the end of calculate_sizes() for details.
