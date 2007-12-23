Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXLWF55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXLWF55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLWF5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:57:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLWF5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:57:47 -0500
Message-ID: <476DF8A9.3080401@redhat.com>
Date: Sat, 22 Dec 2007 23:56:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, mike@halcrow.us,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] (UPDATED) ecryptfs: check for existing key_tfm at mount
 time
References: <476B4CB9.9070700@redhat.com>	<20071221205618.d04bea09.akpm@linux-foundation.org>	<476D4C8D.9080602@redhat.com> <20071222162516.df6fe557.akpm@linux-foundation.org>
In-Reply-To: <20071222162516.df6fe557.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 22 Dec 2007 11:42:37 -0600 Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> Andrew Morton wrote:
>>
>>> It would all look a lot more solid if this locking was retained and both
>>> ecryptfs_tfm_exists() and ecryptfs_add_new_key_tfm() were designed to be
>>> called under key_tfm_list_mutex.
>> Hmm good point, sorry for missing that.  How's this look?
> 
> key_tfm_list_mutex gets used in fs/ecryptfs/main.c but it is static in
> fs/ecryptfs/crypto.c
> 

Ah crud that was a bunk-ism in -mm that I missed.

I'll send another updated patch soon.

-Eric
