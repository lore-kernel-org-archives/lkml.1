Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbYFFB4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbYFFB4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYFFB4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:56:42 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:35051 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbYFFB4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:56:42 -0400
Message-ID: <484898FF.4040701@linux.vnet.ibm.com>
Date: Fri, 06 Jun 2008 07:25:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: clean up checking of  the disabled flag
References: <4848955D.2020302@cn.fujitsu.com>
In-Reply-To: <4848955D.2020302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Those checks are unnecessary, because when the subsystem is disabled
> it can't be mounted, so those functions won't get called.
> 
> The check is needed in functions which will be called in other places
> except cgroup.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Yep, that should work

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
