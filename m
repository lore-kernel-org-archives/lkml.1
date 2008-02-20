Return-Path: <linux-kernel-owner+w=401wt.eu-S1763890AbYBTNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763890AbYBTNzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYBTNzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:55:14 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:43935 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbYBTNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:55:13 -0500
X-Greylist: delayed 168255 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 08:55:12 EST
Message-ID: <47BC312F.2060905@trash.net>
Date: Wed, 20 Feb 2008 14:54:55 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 1/8] [NET]: uninline skb_put, de-bloats a lot
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
In-Reply-To: <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> ~500 files changed
> ...
> kernel/uninlined.c:
>   skb_put                       | +104
>  1 function changed, 104 bytes added, diff: +104
> 
> vmlinux.o:
>  869 functions changed, 198 bytes added, 111003 bytes removed, diff: -110805
> 
> This change is INCOMPLETE, I think that the call to current_text_addr()
> should be rethought but I don't have a clue how to do that.


I guess __builtin_return_address(0) would work.
