Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbXIETfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbXIETfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXIETfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:35:45 -0400
Received: from il.qumranet.com ([82.166.9.18]:51454 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbXIETfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:35:44 -0400
Message-ID: <46DF045F.4020806@qumranet.com>
Date: Wed, 05 Sep 2007 22:32:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-mm@kvack.org, shaohua.li@intel.com,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC]: pte notifiers -- support for external page tables
References: <11890103283456-git-send-email-avi@qumranet.com> <46DEFDF4.5000900@redhat.com> <46DF0013.4060804@qumranet.com> <46DF0234.7090504@redhat.com>
In-Reply-To: <46DF0234.7090504@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
>>
>> I imagine that many of the paravirt_ops mmu hooks will need to be 
>> exposed as pte notifiers.  This can't be done as part of the 
>> paravirt_ops code due to the need to pass high level data structures, 
>> though.
>
> Wait, I thought that paravirt_ops was all on the side of the
> guest kernel, where these host kernel operations are invisible?
>

It is, but the hooks are in much the same places.  It could be argued 
that you'd embed pte notifiers in paravirt_ops for a host kernel, but 
that's not doable because pte notifiers use higher-level data strutures 
(like vmas).

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

