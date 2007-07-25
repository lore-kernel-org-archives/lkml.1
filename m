Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXGYQDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXGYQDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXGYQDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:03:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:20675 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXGYQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VUq2sPkiMUBIXYV0e0Xiy3h9VxCOHLLoeQ21lJRqLXl6fd7zJPXfsE9OLLk1PI9mlcmY6USn9stVZJhj9jX7+rnWufXBDxbZMDJgzCZPl7LQ8rfL3eH8qnnniFOk9IvKj4Lfq+hx29CzNxXHjuiF/St1UIUQ3dIi9TM9Ll+cqCE=
Message-ID: <2c0942db0707250902v58e23d52v434bde82ba28f119@mail.gmail.com>
Date: Wed, 25 Jul 2007 09:02:56 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: -mm merge plans for 2.6.23
Cc: david@lang.hm, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A6DFFD.9030202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
X-Google-Sender-Auth: 975b6243937511f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Rene Herman <rene.herman@gmail.com> wrote:
> Yes, but what's locate's usage scenario? I've never, ever wanted to use it.
> When do you know the name of something but not where it's located, other
> than situations which "which" wouldn't cover and after just having
> installed/unpacked something meaning locate doesn't know about it yet either?

I use it to find source files and documents all the time. One of my
work boxes has <runs a locate work | wc -l> ~38500 files and
directories under my source directory. And then there's the "I wrote
that tech doc two years ago, where was that. Hmm, what did I name it?
Bet it had 323 in the name, and doc in the path."

I'd just like updatedb to amortize its work better. If we had some way
to track all filesystem events, updatedb could keep a live and
accurate index on the filesystem. And this isn't just updatedb that
wants that, beagle and tracker et al also want to know filesystem
events so that they can index the documents themselves as well as the
metadata. And if they do it live, that spreads the cost out, including
the VM pressure.

Ray
