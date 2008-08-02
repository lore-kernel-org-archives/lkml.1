Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYHBIug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYHBIug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 04:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYHBIu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 04:50:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:16825 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYHBIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 04:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=smmHEcCe4ZGXBuTyVbnRxROnxv0pZ1ADdjmazkpL3ZkBXkzqDLs/+MTW0SZOM/xVA2
         0grmwnYYGC5T0OZARqim1puU25knWJsXAnUSKBmvpZ43WYVvHfggAOT5aU8+y5R166pj
         ZOv8XPHFZ9o9ChQCrpt1Ogq9QDXrUfOJfRVVE=
Message-ID: <48941FCD.5060002@gmail.com>
Date: Sat, 02 Aug 2008 10:50:21 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: oleg@tv-sign.ru, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: fix warnings
References: <20080802082454.GB4856@orion>
In-Reply-To: <20080802082454.GB4856@orion>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> proc: fix warnings
> 
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 3 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 4 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 5 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 6 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 7 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 8 has type 'u64'
> fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
> unsigned int', but argument 9 has type 'u64'

right, my bad.

Acked-by: Andrea Righi <righi.andrea@gmail.com>

Thanks!
-Andrea
