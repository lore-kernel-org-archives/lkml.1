Return-Path: <linux-kernel-owner+w=401wt.eu-S1762407AbZEGSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762407AbZEGSNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZEGSM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:12:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760985AbZEGSM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:12:58 -0400
Message-ID: <4A032472.4030106@redhat.com>
Date: Thu, 07 May 2009 21:12:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com>
In-Reply-To: <4A032390.6030100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> What do you think of my mmio hypercall?  That will speed up all mmio
>> to be as fast as a hypercall, and then we can use ordinary mmio/pio
>> writes to trigger things.
>>
>>     
> I like it!
>
> Bigger question is what kind of work goes into making mmio a pv_op (or
> is this already done)?
>
>   

Looks like it isn't there.  But it isn't any different than set_pte - 
convert a write into a hypercall.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

