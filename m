Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYARNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYARNDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbYARNDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:03:07 -0500
Received: from as2.cineca.com ([130.186.84.242]:41777 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586AbYARNDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:03:04 -0500
Message-ID: <4790A379.6090401@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
References: <4790904F.5000101@users.sourceforge.net>	 <20080118123605.GB14339@linux.vnet.ibm.com> <6599ad830801180441o2d60ffc9s47de9362cda40282@mail.gmail.com>
In-Reply-To: <6599ad830801180441o2d60ffc9s47de9362cda40282@mail.gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 14:02:49 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Jan 18, 2008 7:36 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>> On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi wrote:
>>> Allow to limit the block I/O bandwidth for specific process containers
>>> (cgroups) imposing additional delays on I/O requests for those processes
>>> that exceed the limits defined in the control group filesystem.
>>>
>>> Example:
>>>   # mkdir /dev/cgroup
>>>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup
>> Just a minor nit, can't we name it as io, keeping in mind that other
>> controllers are known as cpu and memory?
> 
> Or maybe "blockio"?

Agree, blockio seems better. Not all I/O is performed on block devices
and in this case we're considering block devices only.

-Andrea
