Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZFWRVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZFWRVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZFWRVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:21:02 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:42448 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFWRVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:21:01 -0400
Date: Tue, 23 Jun 2009 13:20:43 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       sfi-devel@simplefirmware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Feng Tang <feng.tang@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/8] SFI: core support
In-reply-to: <20090623075643.GC6397@elte.hu>
Message-id: <alpine.LFD.2.00.0906231312550.21402@localhost.localdomain>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
 <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
 <20090623075643.GC6397@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: #define PREFIX "SFI: "

The SFI code uses all pr_info/debug/warning/err format
and so it looks like the way to go is like this;

#define KMSG_COMPONENT "SFI"
#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt

and get rid of the PREFIX stuff in the actual messages.
Is that the recommended way to go these days?

thanks,
-Len Brown, Intel Open Soruce Technolgy Center
