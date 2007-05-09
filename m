Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbXEIRPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbXEIRPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbXEIRPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:15:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:11882 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbXEIRPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=He81taqpxDZSi45RzxQtwyVAa+BuKxVPbxNibIvtjYefN11bRAyCRgsadfb9uFnO6k/jHCrg07Hgbunvq4G7YDp7hLPcY30c+UGGwiDxX7au9Lenoy72fkszQjN+cDZRSWrRHX1g1uUMnuqh7qncvl+CYg2CJKnh/t+WXA0QXME=
Message-ID: <a36005b50705091015u3b0ccc3brb4cb99fc0fa29d82@mail.gmail.com>
Date: Wed, 9 May 2007 10:15:17 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] stub MADV_FREE implementation
Cc: "Rik van Riel" <riel@redhat.com>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "Jakub Jelinek" <jakub@redhat.com>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20070508160547.e1576146.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au>
	 <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au>
	 <463FF3D3.9060007@redhat.com>
	 <20070508160547.e1576146.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> And has Ulrich indicated that glibc would indeed go out ahead of
> the kernel in this fashion?

Rik is concerned to get a glibc version which allows him to test the
improvements.  That's really not a big problem.  We laready have a
patch for this and can provide appropriate RPMs easily.

I don't want to set a precedence for adding glibc support for phantom
features.  So, I would not add support to the official glibc anyway
until there is a fixed implementation which then also means a fixed
ABI.  So, Andrew, applying the patch won't do any good.
