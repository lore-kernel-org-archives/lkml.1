Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYJ0RMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYJ0RMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYJ0RMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:12:23 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:34061 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJ0RMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:12:22 -0400
Message-ID: <4905F648.4030402@cs.columbia.edu>
Date: Mon, 27 Oct 2008 13:11:36 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Peter Chubb <peterc@gelato.unsw.edu.au>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint	restart
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>	 <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>	 <20081021124130.a002e838.akpm@linux-foundation.org>	 <20081021202410.GA10423@us.ibm.com>	<48FE82DF.6030005@cs.columbia.edu>	 <20081022152804.GA23821@us.ibm.com>	<48FF4EB2.5060206@cs.columbia.edu>	 <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu> <1225125752.12673.79.camel@nimitz>
In-Reply-To: <1225125752.12673.79.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Hansen wrote:
> On Mon, 2008-10-27 at 07:03 -0400, Oren Laadan wrote:
>>> In our implementation, we simply refused to checkpoint setid
>> programs.
>>
>> True. And this works very well for HPC applications.
>>
>> However, it doesn't work so well for server applications, for
>> instance.
>>
>> Also, you could use file system snapshotting to ensure that the file
>> system view does not change, and still face the same issue.
>>
>> So I'm perfectly ok with deferring this discussion to a later time :)
> 
> Oren, is this a good place to stick a process_deny_checkpoint()?  Both
> so we refuse to checkpoint, and document this as something that has to
> be addressed later?

why refuse to checkpoint ?

if I'm root, and I want to checkpoint, and later restart, my sshd server
(assuming we support listening sockets) - then why not ?

we can just let it be, and have the restart fail (if it isn't root that
does the restart); perhaps add something like warn_checkpoint() (similar
to deny, but only warns) ?

Oren.


