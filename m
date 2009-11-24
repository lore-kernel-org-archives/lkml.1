Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZKXJv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZKXJv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932545AbZKXJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:51:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbZKXJvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:51:17 -0500
Message-ID: <4B0BAC76.3080202@redhat.com>
Date: Tue, 24 Nov 2009 11:50:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: kvmmmu tracing
References: <1258974375.7094.158.camel@johannes.local>
In-Reply-To: <1258974375.7094.158.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 01:06 PM, Johannes Berg wrote:
> Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
> the userspace interface for tracing because of the weird
> KVM_MMU_PAGE_PRINTK macro.
>
>    

Can you explain what is wrong with it?

> Maybe we should have a "unsafe for export" flag for events, if they do
> strange things like that?
>
> As it stands, I can't use trace-cmd on an x86 machine that has kvm
> enabled because it will try to read all the kvm stuff. Arguably, it
> should only try to parse it when it needs it (i.e. not for me) but still
> it's very inconvenient to export something to userspace that it cannot
> possibly understand.
>    

Is userspace reading mmutrace.h?  When the structure attributes can be 
exported via /sys/kernel/debug/tracing?


-- 
error compiling committee.c: too many arguments to function

