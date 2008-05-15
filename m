Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYEOJJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYEOJJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYEOJIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:08:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:25820 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYEOJIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=isgj2+qznEKk1Kb5IuE53ZQBaQ4bamZtuAqAPMiM5veaYBR+T4QTN0s4PU6pKiPTgwoKfAH8rkKP84YQgjd6GlDXYIyKDRtliZ/lXLmmIutMBov53r7zpDoGceyKGR/h6SXrAgORUDD591Ls9wO+5VAlTZcn/WNsFBBwlNq1Ubw=
Date: Thu, 15 May 2008 09:12:17 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Kingsley Foreman <kingsley@internode.com.au>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080515091216.GA6550@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B0A599AA8CD34E47901804F014F15903@uglypunk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-05-2008 08:16, Kingsley Foreman wrote:
...
>>>> Ive been using qdisc for quite a while without any problems,
>>>> I just rebuilt a gentoo box with 2.6.25 kernel that does a lot of 
>>>> traffic
>>>> ~1000mbits+ over a bonded interface
>>>>
>>>> Im however seeing a big problem with cbq class dropping packets for no
>>>> reason i can see, and it is causing a lot of speed issues.
...

Do you mean the same box with the same config but the previous kernel
(2.6.24) doesn't show this problem? BTW, what is txqueuelen on this
bond0?

Regards,
Jarek P.
