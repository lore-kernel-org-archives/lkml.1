Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXJCHOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXJCHOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXJCHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:14:41 -0400
Received: from ernst.netinsight.se ([212.247.11.2]:61403 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752007AbXJCHOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:14:40 -0400
Date: Wed, 03 Oct 2007 09:04:23 +0200 (CEST)
Message-Id: <20071003.090423.-2529196.anders@netinsight.se>
To: arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: PROBLEM: high load average when idle
From: Anders =?iso-8859-1?Q?Bostr=F6m?= <anders@bostrom.dyndns.org>
In-Reply-To: <4702D086.3000005@linux.intel.com>
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
	<4702D086.3000005@linux.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AvdV" == Arjan van de Ven <arjan@linux.intel.com> writes:

 AvdV> Anders Boström wrote:
 >> Hi!
 >> 
 >> My computer suffers from high load average when the system is idle,
 >> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .
 >> 
 >> Long story:
 >> 
 >> 2.6.20 and all later versions I've tested, including 2.6.21 and
 >> 2.6.22, make the load average high. Even when the computer is totally
 >> idle (I've tested in single user mode), the load average end up
 >> at ~0.30. The computer is still responsive, and the only fault seems
 >> to be the too high load average. All versions up to and including
 >> 2.6.19.7 is fine, and don't suffer from the problem.

 AvdV> can you tell me if you're tuning ext3 in any way to have a much 
 AvdV> shorter timeout than the standard 5 seconds?

No, I'm using the standard 5 seconds timeout.

/ Anders
