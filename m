Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYAQJbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYAQJbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 04:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYAQJax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 04:30:53 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:33300 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYAQJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 04:30:51 -0500
Message-ID: <478F1FC0.9020709@fr.ibm.com>
Date: Thu, 17 Jan 2008 10:28:32 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Jonathan Corbet <corbet@lwn.net>, Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       drepper@redhat.com, Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
References: <478DFF8F.9030006@openvz.org> <9803.1200493420@vena.lwn.net> <20080117034844.GA27894@ZenIV.linux.org.uk>
In-Reply-To: <20080117034844.GA27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jan 16, 2008 at 07:23:40AM -0700, Jonathan Corbet wrote:
>> Hi, Pavel,
>>
>> [Adding Ulrich]
>>
>>> I use the last bit in the clone_flags for CLONE_LONGARG. When set it
>>> will denote that the child_tidptr is not a pointer to a tid storage,
>>> but the pointer to the struct long_clone_struct which currently 
>>> looks like this:
>> I'm probably just totally off the deep end, but something did occur to
>> me: this looks an awful lot like a special version of the sys_indirect()
>> idea.  Unless it has been somehow decided that sys_indirect() is the
>> wrong idea, might it not be better to look at making that interface
>> solve the extended clone() problem as well?
> 
> Nah, just put an XML parser into the kernel to have the form match the
> contents...
> 
> Al "perhaps we should newgroup alt.tasteless.api for all that stuff" Viro

so you'd rather have new syscalls to support new clone flags ? something
like :

	long sys_clone64(unsigned long flags_high, unsigned long flag_low)
	long sys_unshare64(unsigned long flags_high, unsigned long flag_low)

Thanks,

C.
