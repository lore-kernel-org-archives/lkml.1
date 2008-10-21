Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYJUXPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYJUXPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 19:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJUXPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 19:15:32 -0400
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:4912 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYJUXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 19:15:31 -0400
Message-ID: <48FE62A0.7080202@lougher.demon.co.uk>
Date: Wed, 22 Oct 2008 00:15:44 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Alex Riesen <raa.lkml@gmail.com>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
References: <E1KqrTW-0001x8-3h@dylan> <81b0412b0810211529x3fc85567yc34fd369ff7c8518@mail.gmail.com>
In-Reply-To: <81b0412b0810211529x3fc85567yc34fd369ff7c8518@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen wrote:
> 2008/10/17 Phillip Lougher <phillip@lougher.demon.co.uk>:
>> There are 16 patches in the patch set, and the patches are against the
>> latest linux-next tree (linux 2.6.27-next-20081016).
> 
> You better don't base anything off linux-next. These are not stable: there
> can be even something in the tree you mentioned which will never end
> up in the mainline and if your patches depend on it they wont apply to
> something like v2.6.26.2.

Definately, there's some d_obtain_alias stuff in linux-next which has 
been there since linux-2.6.27-rc4-next.  I thought it would make it into 
the final 2.6.27 but it didn't.

I thought linux-next *was* the tree that new patches should be based 
off.  However, the relationship between linux-2.6.git, linux-next.git, 
and the  -mm patch series seems to be a little vague to me, not to 
mention where the linux-staging tree fits into all this.

Phillip
