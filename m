Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbYB1WKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbYB1WKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYB1WJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:09:52 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29942 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657AbYB1WJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:09:51 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="994537"
Message-ID: <47C73121.2000109@qualcomm.com>
Date: Thu, 28 Feb 2008 14:09:37 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com>
In-Reply-To: <20080228163303.GA6195@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> -allow stop_mahcine_run() to call a function on all cpus. Calling 
>  stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
>  stop_machine_run() proceeds as normal until the calling cpu has
>  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
> 

Jason, we're actually trying to reduce the usage of the stop_machine in 
general. It's a very big hammer that kills latencies and stuff. It'd be nice 
if we did not introduce any more dependencies on it. I guess in some case 
there is simply no other way to handle what need to do. But please think twice
(or more :)).

Max


