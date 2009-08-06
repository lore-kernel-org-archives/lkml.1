Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZHFEfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZHFEfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZHFEfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:35:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZHFEfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:35:46 -0400
Message-ID: <4A7A5D9D.7030305@zytor.com>
Date: Wed, 05 Aug 2009 21:35:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
 	of device.
References: <20090802215444.4198.83094.stgit@notabene.brown>	<20090802215818.4198.77041.stgit@notabene.brown>	<4A7A0287.5010505@zytor.com>	<170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>	<4A7A2EA6.9020603@zytor.com> <19066.19060.95471.616532@notabene.brown>
In-Reply-To: <19066.19060.95471.616532@notabene.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 08:13 PM, Neil Brown wrote:

> 
> Thanks for the reports guys.
> 
> I managed to reproduce the lockup and I think this patch should fix
> it.
> If you could review/test I would appreciate it.
> 
> Thanks,
> NeilBrown
> 

This patch makes my system boot, whereas previously it would deadlock
100% of the time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

