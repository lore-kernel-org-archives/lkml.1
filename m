Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbYDUNii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbYDUNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbYDUNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:38:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47318 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbYDUNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:38:04 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <6736017.1208784680882.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 21 Apr 2008 22:31:20 +0900 (JST)
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: Re: -mm merge plans for 2.6.26 (memcgroup)
Cc: Andi Kleen <andi@firstfloor.org>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, menage@google.com,
       xemul@openvz.org, shiwh@cn.fujitsu.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0804211301500.20183@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <Pine.LNX.4.64.0804211301500.20183@blonde.site>
 <20080420072053.6bcb7884.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804210004470.1630@blonde.site>
 <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
 <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com>
 <20080421064725.GA32214@balbir.in.ibm.com> <Pine.LNX.4.64.0804211158001.10521@blonde.site>
 <480C7D4C.1070502@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Mon, 21 Apr 2008, Andi Kleen wrote:
>> Hugh Dickins wrote:
>> > On Mon, 21 Apr 2008, Balbir Singh wrote:
>> > I've added Andi to the Cc's, I don't want to sneak away something
>> > he's expecting there.  If 2.6.25 had gone out with a convention that
>> > controller infrastructure gets compiled in, but has then to be enabled
>> > at boottime or runtime, okay; 
>> 
>> That is what I have been expecting yes.
>> 
>> If later the slow down is fixed it can be also enabled by default too.
>
>It is disabled by default, in the config; and Paul/Balbir already
>provided the cgroup_disable=memory bootoption to override that.
>
>Is it wise to add an additional hurdle now that 2.6.25 has gone out?
>Is it wise to switch it around in future?  Seems a source of confusion
>to me (I already wasted time testing the same things twice in -mm
>because of this).
>
>I guess Andrew needs to make an executive decision!
>Whichever way round, we ought to clarify the config helptext.
>
Hmm, IMHO, following is a  way.
1. set default config=y and change the config helptext's to
   "This feature is disabled at boot time as default..."
2. add a switch to enable memory conroller after boot. (if possible)

Adding "if"s to page-fault path is too bad ?

About overhead, I think we can reduce it to some extent but amounts of
codes to be added will increase overhead again. Most of features 
is not implemented now (I think).

I'm now preparing performance improvement patches on 2.6.25 and will be
able to show some numbers in the current kernel.

Thanks,
-Kame



 




