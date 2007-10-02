Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXJBXOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXJBXOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXJBXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:14:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:20553 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbXJBXOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="161087759"
Message-ID: <4702D086.3000005@linux.intel.com>
Date: Tue, 02 Oct 2007 16:13:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Anders_Bostr=F6m?= <anders@bostrom.dyndns.org>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
In-Reply-To: <20071002.233731.119908363.anders@bostrom.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Boström wrote:
> Hi!
> 
> My computer suffers from high load average when the system is idle,
> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .
> 
> Long story:
> 
> 2.6.20 and all later versions I've tested, including 2.6.21 and
> 2.6.22, make the load average high. Even when the computer is totally
> idle (I've tested in single user mode), the load average end up
> at ~0.30. The computer is still responsive, and the only fault seems
> to be the too high load average. All versions up to and including
> 2.6.19.7 is fine, and don't suffer from the problem.
> 


can you tell me if you're tuning ext3 in any way to have a much 
shorter timeout than the standard 5 seconds?
