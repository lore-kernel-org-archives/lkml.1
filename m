Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbZEFHMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbZEFHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZEFHMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:12:33 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:62574 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZEFHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ApjAYitQO+MR+mClWwgoB4FglijTp/xsiT9yzpEFMd98gGlmqRMWDY4Md4NoGWIMpk
         31JsVaAU1p9Vr6Tl9XRvzWCEGv+i6Jk0KqO5HTcxxkY3FK3AkwLGnWl4V6SuceOyXOT2
         LTHRPqGIw7f83ii15waofw1cjzb2lyfwNdEmU=
Date: Wed, 6 May 2009 11:12:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - fix comment
	and make it __init
Message-ID: <20090506071228.GD4865@lenovo>
References: <20090506061923.GA4865@lenovo> <20090506155145.e657b271.minchan.kim@barrios-desktop> <20090506070323.GC4865@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506070323.GC4865@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, May 06, 2009 at 11:03:23AM +0400]
... 
| Thanks Minchan. Actually it's not a typo :)
| module_init function is supposed to be __initcall
| function anyway. But it's confusing I could fix
| changelog.
| 
| 	-- Cyrill

Andrew, could you s/module_init/__init/ in changelog
please?

	-- Cyrill
