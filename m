Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbZJOXKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbZJOXKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 19:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763264AbZJOXKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 19:10:44 -0400
Received: from mail.crca.org.au ([67.207.131.56]:50951 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763253AbZJOXKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 19:10:43 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AD7ABE7.40105@crca.org.au>
Date: Fri, 16 Oct 2009 10:10:31 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] swap_info: private to swapfile.c
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils> <Pine.LNX.4.64.0910150144310.3291@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910150144310.3291@sister.anvils>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh.

Hugh Dickins wrote:
> The swap_info_struct is mostly private to mm/swapfile.c, with only
> one other in-tree user: get_swap_bio().  Adjust its interface to
> map_swap_page(), so that we can then remove get_swap_info_struct().
> 
> But there is a popular user out-of-tree, TuxOnIce: so leave the
> declaration of swap_info_struct in linux/swap.h.

Sorry for the delay in replying.

I don't mind if you don't leave swap_info_struct in
include/linux/swap.h. I'm currently reworking my swap support anyway,
adding support for honouring the priority field. I've also recently
learned that under some circumstances, allocating all available swap can
take quite a while (I have a user who is hibernating with 32GB of RAM!),
so I've been thinking about what I can do to optimise that.

Regards,

Nigel
