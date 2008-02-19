Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbYBSPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbYBSPr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYBSPrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:47:51 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:35678 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYBSPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:47:50 -0500
Message-ID: <47BAF9FA.70603@tiscali.nl>
Date: Tue, 19 Feb 2008 16:47:06 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/ext4/mballoc.c: Convert to list_for_each_entry_rcu()
References: <47BA2356.90203@tiscali.nl> <20080219094945.GA6743@skywalker>
In-Reply-To: <20080219094945.GA6743@skywalker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V wrote:
> On Tue, Feb 19, 2008 at 01:31:18AM +0100, Roel Kluin wrote:
>> Please verify, this patch was not yet tested
>> ---
>> Convert list_for_each_rcu() to list_for_each_entry_rcu()
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> 
> 
> NACK. This patch doesn't build. You have extra cur in the conversion.
> Right changes attached. 
> 
> ext4:  Convert list_for_each_rcu() to list_for_each_entry_rcu()
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> The list_for_each_entry_rcu() primitive should be used instead of
> list_for_each_rcu(), as the former is easier to use and provides
> better type safety.


Thanks for your review and correction,

Roel
