Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYAPPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYAPPGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYAPPGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:06:11 -0500
Received: from sacred.ru ([62.205.161.221]:48043 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYAPPGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:06:10 -0500
Message-ID: <478E1D3A.1060904@openvz.org>
Date: Wed, 16 Jan 2008 18:05:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, drepper@redhat.com,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Extend sys_clone and sys_unshare system calls API
References: <9803.1200493420@vena.lwn.net>
In-Reply-To: <9803.1200493420@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 16 Jan 2008 18:05:11 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> Hi, Pavel,
> 
> [Adding Ulrich]
> 
>> I use the last bit in the clone_flags for CLONE_LONGARG. When set it
>> will denote that the child_tidptr is not a pointer to a tid storage,
>> but the pointer to the struct long_clone_struct which currently 
>> looks like this:
> 
> I'm probably just totally off the deep end, but something did occur to
> me: this looks an awful lot like a special version of the sys_indirect()
> idea.  Unless it has been somehow decided that sys_indirect() is the
> wrong idea, might it not be better to look at making that interface
> solve the extended clone() problem as well?

We has such an idea, but as far as I know sys_indirect idea is
not yet accomplished. So I risked to propose such an extension
for sys_clone.

If Andrew says that sys_indirect is on its way to -mm tree, then
we'll surely wait and use this one for namespaces.

> jon
> 

Thanks,
Pavel
