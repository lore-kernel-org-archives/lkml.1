Return-Path: <linux-kernel-owner+w=401wt.eu-S1422646AbXCGJaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422646AbXCGJaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXCGJaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:30:07 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:41204 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422646AbXCGJaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:30:03 -0500
Message-ID: <45EE8950.7070103@sw.ru>
Date: Wed, 07 Mar 2007 12:43:44 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: balbir@in.ibm.com, Andrew Morton <akpm@osdl.org>,
       Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org
Subject: Re: [RFC][PATCH 0/7] Resource controllers based on process containers
References: <45ED7DEC.7010403@sw.ru> <45EE6112.7050702@in.ibm.com> <45EE6A77.7070002@sw.ru>
In-Reply-To: <45EE6A77.7070002@sw.ru>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Balbir Singh wrote:
> 
>>Pavel Emelianov wrote:
>>
>>>This patchset adds RSS, accounting and control and
>>>limiting the number of tasks and files within container.
>>>
>>>Based on top of Paul Menage's container subsystem v7
>>>
>>>RSS controller includes per-container RSS accounter,
>>>reclamation and OOM killer. It behaves like standalone
>>>machine - when container runs out of resources it tries
>>>to reclaim some pages and if it doesn't succeed in it
>>>kills some task which mm_struct belongs to container in
>>>question.
>>>
>>>Num tasks and files containers are very simple and
>>>self-descriptive from code.
>>>
>>>As discussed before when a task moves from one container
>>>to another no resources follow it - they keep holding the
>>>container they were allocated in.
>>>
>>
>>I have one problem with the patchset, I cannot compile
>>the patches individually and some of the code is hard
>>to read as it depends on functions from future patches.
>>Patch 2, 3 and 4 fail to compile without patch 5 applied.
>>
>>Patch 1 failed to apply with a reject in kernel/Makefile
>>I applied it on top of 2.6.20 with all of Paul Menage's
>>patches (all 7).
maybe Paul's patch should be taken w/o subsystems examples
(CKRM, UBC), i.e. first 3 patches only?

Kirill
