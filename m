Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYDDJrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYDDJrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYDDJrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:47:35 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52747 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYDDJre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:47:34 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Paul Menage'" <menage@google.com>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>,
       <m-takahashi@ex.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>	 <008501c893dc$3206e520$9614af60$@jp.nec.com>	 <6599ad830804030835s73392db0v29426425c0ea4381@mail.gmail.com>	 <003401c8961c$00eea670$02cbf350$@jp.nec.com> <6599ad830804040200u1ed48f4bxecaa664862cf30a5@mail.gmail.com>
In-Reply-To: <6599ad830804040200u1ed48f4bxecaa664862cf30a5@mail.gmail.com>
Subject: RE: [RFC][patch 8/11][CFQ-cgroup] Control cfq_data per cgroup
Date: Fri, 4 Apr 2008 18:46:53 +0900
Message-Id: <018c01c89638$d01d3850$7057a8f0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciWMlNK5VFnln8eSS+k6ivkjl3ahQAANC3A
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> On Thu, Apr 3, 2008 at 11:20 PM, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
> wrote:
> >
> >  So that you say, root subsystem state maybe keep a reference locally.
> >  For example, create a variable for root subsystem state and
> >  store the pointer when making subsystem state first.
> 
> Yes, that's what I'm suggesting.
> 
> >
> >  However, I think that it is smart to calculate root group of subsystems
> >  when needing its information.
> 
> I don't see why it's better to go through the cgroup subsystem to
> retrieve the reference.
> 

If program have temporary data, it may cause inconsistency.
I think that information should be referred to original(control mechanism).

Information of cgroup is controlled at cgroup subsystem (and cgroupfs_root).
So, I think that it's better to query into cgroup subsystem.

Now, cgroup susbsystem would not change root group.
Therefore, system would also runs by your suggestion.

I will consider this issue.

Thanks,
 Satoshi UCHIDA.


