Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYEQFvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYEQFvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 01:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYEQFvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 01:51:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:1235 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYEQFvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 01:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Cwwrw3xXu2HGgbpRy0epIMHsv/xtztoE8ZA0S8TbWS5jTu9kxcGgQQmrC1AKQCQGcLS2XxcN1Ifggegvmr4i7LY4rTZjEoMrGaCzUlTDVD7iLj0jKWBGGjJLyiowP0IJZ/lVm2VnLi21YDxyt0Zb0bCULjHW9JoBt4SSNT29XMk=
Message-ID: <482E7246.5070607@gmail.com>
Date: Sat, 17 May 2008 14:51:02 +0900
From: MinChan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 00/14] VM pageout scalability improvements (V7)
References: <20080516183207.361608893@redhat.com>
In-Reply-To: <20080516183207.361608893@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
> 
> Against 2.6.25-rc2-mm1
> 

I think it's typo error. 
This patch is based on 2.6.26-rc2-mm1. :-)


> This patch series improves VM scalability by:
