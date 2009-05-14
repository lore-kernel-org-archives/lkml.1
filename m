Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZENXQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZENXQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZENXQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:16:10 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50574 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZENXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:16:09 -0400
Message-ID: <4A0CA67C.30507@oracle.com>
Date: Thu, 14 May 2009 16:17:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: jbarnes@virtuousgeek.org, Andrew Morton <akpm@linux-foundation.org>,
       eric@anholt.net, airlied@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq, intel_fb: fix sysrq g collision
References: <4A0CA203.7050907@windriver.com>
In-Reply-To: <4A0CA203.7050907@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A0CA5FB.03B8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> This is patch is both a clean up and a regression fix because two things
> in the mainline kernel can register for sysrq-g, which is certainly a
> problem when you want to use both.
> 
> I talked to Randy and Jesse briefly about changing the intel fb video
> driver to use 'v' instead of 'g' and they agreed it would be ok to see a
> patch.  Hopefully each will ack this patch, or discuss it further.   If
> they ack the patch, I can send it on to Linus for consideration.
> 
> The long term intent here is to get mode switching with a generic kernel
> debug front end, with the short term intent to fix the sysrq collision.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
