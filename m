Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZCUQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZCUQVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZCUQVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:21:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCUQVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sa9dzd7Xt4xaRwez0R+fFa3gR/ZVkFSq+w8c/gFRgdE9IgFKONt/1KdsVOYzOmUkBm
         BChlLUg5Hqmby0z3Oe7aRmkY38dMA1gAFUcr8keWo9hhldFC+45JJQoDr7mCaRCWNvPi
         ESKzoNjv7/O+AA1sHCdEbJzRDLiBz5ZEduBow=
MIME-Version: 1.0
In-Reply-To: <20090321052416.6eb38759.akpm@linux-foundation.org>
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
	 <49C3F1EE.90903@vflare.org>
	 <20090321032137.8dc113e8.akpm@linux-foundation.org>
	 <49C4D9C4.1030103@vflare.org>
	 <20090321052416.6eb38759.akpm@linux-foundation.org>
Date: Sat, 21 Mar 2009 18:21:01 +0200
X-Google-Sender-Auth: bfc1fd3a16d2aede
Message-ID: <84144f020903210921m7603b9bfwed948a016b2f9429@mail.gmail.com>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 2:24 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I assumed that you were referring to moving xvmalloc() down into
> drivers/block.  That would be bad, because then xvmalloc() will _never_ be
> usable by anything other than ramzblock <new name!>?

Who is going to use it? The only reason compcache needs something
special is because it wants to take advantage of GFP_HIGHMEM pages.
Are there other subsystems that need this capability as well?
