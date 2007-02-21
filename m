Return-Path: <linux-kernel-owner+w=401wt.eu-S1422759AbXBUSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422759AbXBUSV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBUSV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:21:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:34367 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422759AbXBUSV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:21:58 -0500
Message-ID: <45DC8D97.9060408@qumranet.com>
Date: Wed, 21 Feb 2007 20:21:11 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/6] KVM userspace interface updates for 2.6.21
References: <45DC8B6E.5050205@qumranet.com>
In-Reply-To: <45DC8B6E.5050205@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> The following patchset moves the kvm userspace interface from having a 
> single fd, to having three types of file descriptors:

Andrew, while the 2.6.21 merge window has closed, please consider 
applying this to 2.6.21 anyway.  At least one major distribution 
(Fedora) is planning to ship 2.6.21 in its next release, and it would be 
a shame not to give them the stable API they have come not to expect, 
especially as they will support it in their GUI management tools.

I plan two or three other changes over the next few days, and then 
devote the rest of 2.6.21 to working out kinks.  Not that I expect many 
-- the changes are fairly simple.  The last change would be adding a 
forwards and backwards compatible feature availability interface so we 
can extend it later.

The patchset, along with the previous fixset, is available as a git tree 
from git://kvm.qumranet.com/home/avi/kvm/linux-2.6.  You may wish to 
plant it in your little git forest.

[Non-Andrews: please don't clone from this.  Read 
http://kvm.qumranet.com/kvmwiki/Code instead]

-- 
error compiling committee.c: too many arguments to function

