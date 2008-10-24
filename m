Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYJXU7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYJXU7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYJXU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:59:09 -0400
Received: from gw.goop.org ([64.81.55.164]:34158 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYJXU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:59:08 -0400
Message-ID: <49023712.4030201@goop.org>
Date: Fri, 24 Oct 2008 13:58:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: Re: [PATCH] x86: remove dead BIO_VMERGE_BOUNDARY definition
References: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081024143836K.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> The block layer dropped the virtual merge feature
> (b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY
> definition is meaningless now.
>   

Hm, I think we still need something here, no?

I have a couple of patches to make x86 use BIOVEC_PHYS_MERGEABLE 
instead, which would probably apply to other arches.

     J
