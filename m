Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYGJAas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYGJAas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYGJAak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:30:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13282 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYGJAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:30:39 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5335"; a="4584774"
Message-ID: <4875582D.4040901@qualcomm.com>
Date: Wed, 09 Jul 2008 17:30:37 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.02838.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au>
In-Reply-To: <200807081756.47140.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> stop_machine creates a kthread which creates kernel threads.  We can
> create those threads directly and simplify things a little.  Some care
> must be taken with CPU hotunplug, which has special needs, but that code
> seems more robust than it was in the past.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Rusty,

You mentioned (in private conversation) that you were going to add some 
logic that checks whether CPU is running user-space code and not holding 
any locks to avoid scheduling stop_machine thread on it. Was it supposed 
to be part of this patch ?

Max
