Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbYASR5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbYASR5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 12:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYASR5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 12:57:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33720 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYASR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 12:57:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479239F9.6020801@s5r6.in-berlin.de>
Date: Sat, 19 Jan 2008 18:57:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Rafael Sisto <rafael.sisto@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>	 <20080119134837.GA15610@ghostprotocols.net>	 <ee3dc96c0801190621p1970086fj218178a7519fe4af@mail.gmail.com>	 <20080119143051.GB9896@lug-owl.de>	 <ee3dc96c0801190657x54edb8cve8a4c09a6efbbb2a@mail.gmail.com>	 <479216AF.2080307@s5r6.in-berlin.de> <ee3dc96c0801190815g1e658606ja982e2b9f1e82e70@mail.gmail.com>
In-Reply-To: <ee3dc96c0801190815g1e658606ja982e2b9f1e82e70@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Sisto wrote:
>> Did you already discuss your problems regarding design and
>> implementation with your teachers before turning to LKML for advice on
>> your homework?
> 
> Yes, the thing is, that this is a research project, and we don't get
> much information from the teachers...
> We must research on our own.

Perhaps the teachers don't prepare you well enough but are not aware of
this issue.  Also, if you go as far as asking people here to show you
example code (rather than for example posting your own draft code or
pseudo code and asking for comments), does this still count as
researching on your own?

[...]
> And I think this is a kernel development issue.

Yes, but AFAIU with the primary goal of you learning something, rather
than to advance the Linux program.  So, kernelnewbies might be a better
list; but still, I am more irritated about /what/ you ask.


A few comments on your earlier posts:
>>>>> Or else, where can I find some more information about what the
>>>>> parameters mean?

To find out how things work in a complex C program like the kernel,
tools like LXR and cscope/ kscope can be quite helpful.  In particular,
they help navigate between definitions and call sites.
http://lxr.free-electrons.com/
http://lxr.linux.no/linux
http://kscope.sourceforge.net/

>>> we have to build something
>>> like IPC, but simpler. we have a "get" system call (we thought we
>>> would just create a file in /tmp, not use it from the kernel, just
>>> create it) and then the users that want to access the shared memory
>>> will call the system call "attach". That will map the file into user
>>> space, as shared.

Why back the shared memory with a file?  Wouldn't a memory buffer suffice?
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/
