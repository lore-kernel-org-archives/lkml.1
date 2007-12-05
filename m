Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXLEHMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXLEHMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXLEHL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:11:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:40145 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXLEHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:11:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rv+Ey7w+Fe8Q/Ibm6QZDX+kI9e6RcX23+4NsbXLLH2UTwWvdYpYKaGqcdPJbm3ehXJ5h07niF74TA+Zx3h2B6cRlCd7JJat81PACVGR09sUsWPJoX1ayH/FDLQh/L76qLUpiT1Sh8mlcK+kRAOnTmcTAf/vOJVT5tYam3U0NLjw=
Message-ID: <47564F35.30706@gmail.com>
Date: Wed, 05 Dec 2007 16:11:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
References: <47555AF1.8090304@gmail.com> <20071204150734.GE6113@hacking> <47557076.8080508@gmail.com> <20071205070127.GG2460@hacking>
In-Reply-To: <20071205070127.GG2460@hacking>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
>>> I think, you forgot to free(3) the memory you calloc(3)'ed and
>>> malloc(3)'ed above.
>> It's a simple program where whole body is in main().  Why bother?
>> What's the benefit of adding hash-table iterating free logic?
>>
> 
> Personally, I think memory leaks are bugs. And we hate bugs. ;)

Trust me.  As a person buried alive in bug reports, I hate bugs too.  I
just don't agree that this type of programs should free all its
resources before exiting.  How about adding a comment saying /* we're
going out anyway, don't bother freeing hashtable */?

-- 
tejun
