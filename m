Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZICNrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZICNrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZICNrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:47:05 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44597 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbZICNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VJMcqWOxBiVNHl8QJsdYgRAmmALbv/6Z+yioOy+q2x6PABQry/gAlfSSxqTUf/UrBQ
         nMzyZhTxoNVaov9tSHGc41sxkhZMNfumbcDyZPI5QRVsI+/gbjCWFAlkJI8GJhShvhu7
         FbPiTgAL7GpWW2dKv16Yvwpe8cM4TQcQas9kg=
Message-ID: <4A9FC8DA.4090001@gmail.com>
Date: Thu, 03 Sep 2009 15:47:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] core: allow setrlimit to non-current tasks
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com> <20090902135024.GA6452@redhat.com> <4A9EBCF8.1020609@gmail.com> <20090902215101.GA4767@redhat.com>
In-Reply-To: <20090902215101.GA4767@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2009 11:51 PM, Oleg Nesterov wrote:
> On 09/02, Jiri Slaby wrote:
>> I can't think of anything else than doing all the checks and updates
>> under alloc_lock, introducing coarse grained static mutex in setrlimit
>> to protect it,
> 
> Oh, please don't ;)
> 
> Or I missed your point?
> 
> 
> But if you mean this series, then yes, I agree. 

Yes, I meant those. But I don't know what do you agree with :).

> We should try to do something
> to ensure that at least rlim_max can be always lowered when admin writes to
> /proc/pid/limits.

Yes, that's what I asked about when I wrote the three options which I
was able to think of above. So any other ideas about how to elegantly
protect against sys_setrlimit vs. admin+/proc/*/limits race?

Thanks a heap.
