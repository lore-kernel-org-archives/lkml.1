Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYHEXZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYHEXZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYHEXZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYHEXZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:25:02 -0400
Message-ID: <4898DBD8.4000002@zytor.com>
Date: Tue, 05 Aug 2008 16:01:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Peter, Andrew,
> 
> Please check dyn_array support for x86
> v3: split changing to nr_irqs to small patches
>     fix checkpatch error
>     reorder the patch sequence to make dyn_array support go at first
> 	so could use that with arrays other than NR_IRQS
> 

The real issue is that I think Eric is right: the dyn_array is an 
interesting data structure, but it's the wrong solution for the problem. 
  A static array would have to be ridiculously large given the potential 
number of interrupt sources.

	-hpa

