Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbXLSLj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbXLSLj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXLSLju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:39:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:33878 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXLSLjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:39:49 -0500
Message-ID: <47690304.1090903@qumranet.com>
Date: Wed, 19 Dec 2007 13:39:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu> <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com>
In-Reply-To: <4768FE27.7020305@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>  
> Testing shows wrmsr and rdtsc function normally.
>
> I'll try pinning the vcpus to cpus and see if that helps.
>

It does.

-- 
error compiling committee.c: too many arguments to function

