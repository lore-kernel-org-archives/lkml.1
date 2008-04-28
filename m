Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbYD1GQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbYD1GQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYD1GQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:16:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:62892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYD1GQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=Jskxk0u8LFI3mV3/b9dcK7sI/GflJY950Q/UQ+XnsnPbnnAvJNYnvlMM1+OkhcfB6tRA/1/m75z0lKOjEa9syUgEOflier68tE0445hL4U9hUSAKTksrK2RVpnHqsjrre/FTv31C2qdDLNFiN4fEWEt5Uient9VD3qH0lEU2zNc=
Date: Mon, 28 Apr 2008 14:14:45 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Paul Jackson <pj@sgi.com>
cc: Bert Wesarg <bert.wesarg@googlemail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] Fix calculus of bitmap_scnprintf_len()
In-Reply-To: <20080427160118.ad4cadf0.pj@sgi.com>
Message-ID: <alpine.LFD.1.00.0804281414020.2870@localhost.localdomain>
References: <1209329003-22036-1-git-send-email-bert.wesarg@googlemail.com> <20080427160118.ad4cadf0.pj@sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Paul Jackson wrote:

> Bert wrote:
>> The function bitmap_scnprintf_len() is currently not used
>
> How about we just remove that function?

I am afraid no. See:

include/linux/cpumask.h:292:    return bitmap_scnprintf_len(len);

