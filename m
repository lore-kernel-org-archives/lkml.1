Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZILLlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZILLlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZILLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:41:39 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:55946 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbZILLlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=szS17dWfoZcAf8vxEPEi49fy8vUkdSSReenEdoI0HsKeym84p86V6ffwNJSdWLK6Nf
         oNsZMO80TAxNVK4593ApIsF62SHJrsQa8FzujqY0LZOBVzjODuYQjoRBSvZc0I1dlW13
         8wYUNpul6jBxZCtgYhx4OKagdpaeh3RQXeCks=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909121218020.488@sister.anvils>
References: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org> 
	<Pine.LNX.4.64.0908241258070.27704@sister.anvils> <4A929BF5.2050105@gmail.com> 
	<Pine.LNX.4.64.0908241532470.9322@sister.anvils> <8bd0f97a0909110703o4d496a45jddc0d7d6fd8674b4@mail.gmail.com> 
	<Pine.LNX.4.64.0909121212560.488@sister.anvils> <Pine.LNX.4.64.0909121218020.488@sister.anvils>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 12 Sep 2009 07:41:22 -0400
Message-ID: <8bd0f97a0909120441y764174d3pc78929438492c6dd@mail.gmail.com>
Subject: Re: [PATCH] fix undefined reference to user_shm_unlock
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Huber <shuber2@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>,
       James Morris <jmorris@namei.org>, William Irwin <wli@movementarian.org>,
       Mel Gorman <mel@csn.ul.ie>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 07:21, Hugh Dickins wrote:
> My 353d5c30c666580347515da609dd74a2b8e9b828 "mm: fix hugetlb bug due to
> user_shm_unlock call" broke the CONFIG_SYSVIPC !CONFIG_MMU build of both
> 2.6.31 and 2.6.30.6: "undefined reference to `user_shm_unlock'".
>
> gcc didn't understand my comment! so couldn't figure out to optimize
> away user_shm_unlock() from the error path in the hugetlb-less case,
> as it does elsewhere.  Help it to do so, in a language it understands.

thanks, this works for me

> Cc: stable@kernel.org

should go into 2.6.30.7 and 2.6.31.1
-mike
