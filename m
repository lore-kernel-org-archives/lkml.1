Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYBAR5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYBAR5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYBAR5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:57:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYBAR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:57:23 -0500
Message-ID: <47A35D55.8080708@zytor.com>
Date: Fri, 01 Feb 2008 09:56:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Yi Yang <yi.y.yang@intel.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>  <1201043126.3861.5.camel@yangyi-dev.bj.intel.com> <1201562058.12722.9.camel@yangyi-dev.bj.intel.com> <alpine.DEB.1.00.0802010830560.7110@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.1.00.0802010830560.7110@twinlark.arctic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> why do we need another kernel cpuid reading method when sched_setaffinity 
> exists and cpuid is available in ring3?

Because /dev/cpu/*/cpuid:

a) predates sched_setaffinity by quite a few years
b) is already widely used
c) doesn't have issues with relative priorities (using sched_setaffinity
    can easily wait forever.)
d) can be accessed by unprivileged processes given appropriate device
    info.

	-hpa
