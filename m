Return-Path: <linux-kernel-owner+w=401wt.eu-S935816AbZDITrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbZDITrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbZDITrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:47:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34525 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935621AbZDITrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:47:06 -0400
Date: Thu, 9 Apr 2009 12:49:12 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible
	ptrace issue?)
Message-ID: <20090409194912.GA30645@us.ibm.com>
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala [galak@kernel.crashing.org] wrote:
>
> On Apr 9, 2009, at 10:43 AM, Kumar Gala wrote:
>
>> I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in 2.6.29.  
>> We have a slightly older LTP version (20080131) that we run on some 
>> embedded PPC boards.  If I run the syscall tests on 2.6.29 things pass as 

Will try to repro on a normal machine, but can you attach the /proc/pid/status
(and possibly the stack) of the parent of the 'recv01' ?

If the parent is 'init', is there anything special about the init on your board
or on the simulator - like are you running the tests in a container ?

Sukadev
