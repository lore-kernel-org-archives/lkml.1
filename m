Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYDKE6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYDKE6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYDKE6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:58:15 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:51101 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYDKE6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:58:13 -0400
Message-ID: <47FEEF6F.2000505@linux.vnet.ibm.com>
Date: Fri, 11 Apr 2008 10:26:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain> <20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com> <47FEE89A.1010102@linux.vnet.ibm.com> <20080411134739.1aae8bae.kamezawa.hiroyu@jp.fujitsu.com> <47FEED67.1080006@linux.vnet.ibm.com> <20080411135810.87536503.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080411135810.87536503.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 11 Apr 2008 10:17:35 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Good question. It is possible that clone() was called with CLONE_VM without
>> CLONE_THREAD. In which case we have threads sharing the VM without a thread
>> group leader. Please see zap_threads() for a similar search pattern.
>>
> Oh. thank you for kindly explanation.
> 
> I'll test this on 2.6.25-rc8-mm2.
> 

Thanks for the review and help with testing.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
