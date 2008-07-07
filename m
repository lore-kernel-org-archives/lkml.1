Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYGGMNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYGGMNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGGMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:12:58 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:63601 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYGGMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=fzuzYknGHslUSCDRIZfHeDaY6URjB/66hB7Ht7OTmIwC0nVWG/HyvPXrsH1cTglwSd
         64os7USTP8D9PFM5t+vgiwtQW75vGWuiWbVu7Q0P4SLjTQbcENNfXiV5CUMLEiBDX+XQ
         uzHDf9Yc9woCxyZKBJeE/wZQ3zoKUM3BOL900=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>
	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
	<m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
	<486B8B6C.2050109@firstfloor.org>
	<m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org>
	<m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com>
Date: Mon, 07 Jul 2008 14:12:56 +0200
In-Reply-To: <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com> (Vitaly
	Mayatskikh's message of "Mon, 07 Jul 2008 14:09:10 +0200")
Message-ID: <m3zlotx587.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

>> one), by limiting the byte-for-byte one to be within a page, but that 
>> would be a "future enhancement" thing.
>
> Btw, how much does it cost to CPU to do a fault? Can it be compared with
> average time of find_vma()?

Remark: this is for preventing fault in memset, not byte-to-byte copy.

-- 
wbr, Vitaly
