Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYBSPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYBSPRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYBSPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:17:32 -0500
Received: from sacred.ru ([62.205.161.221]:50410 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbYBSPRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:17:32 -0500
Message-ID: <47BAF2E5.8050001@openvz.org>
Date: Tue, 19 Feb 2008 18:16:53 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: Improve init/Kconfig help descriptions [PATCH 3/9]
References: <20080219140609.GA26619@tull.net> <20080219143307.GA27352@tull.net> <47BAEABF.6050005@openvz.org> <20080219151028.GA28294@tull.net>
In-Reply-To: <20080219151028.GA28294@tull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 19 Feb 2008 18:16:45 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Andrew wrote:
> On Tue, Feb 19, 2008 at 05:42:07PM +0300, Pavel Emelyanov wrote:
>> Nick Andrew wrote:
>>> On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
>>>> Here is a series of 9 patches to init/Kconfig intended to improve the
>>>> usefulness and consistency of the help descriptions. The patches are
>>>> against linux-2.6.24.2.
>>>> [...]
>>>> Patch 3
>>>> 	USER_NS
>>>> 	PID_NS
>> What about UTS_NS, IPC_NS and NET_NS? 
>> Their descriptions can be improved in the same way :)
> 
> So far I have edited only init/Kconfig, that's what these 9
> patches are for. Next I'll do block/Kconfig. Eventually I expect
> to get to net/Kconfig which is where NET_NS is configured,
> but I don't know where UTS_NS and IPC_NS come from in 2.6.24.2.
> 
> I expect I'll have to start patching against a git tree soon,
> to be sure to see the latest code. I assume this should be
> Linus' tree?

Both UTS_NS and IPC_NS are in init/Kconfg. At least they are
in 2.6.25-rc2 :)

> Is there any actual documentation on user namespaces and friends?

Hardly :(

> I think I grasp the pid namespaces concept; I am having a little
> difficulty visualising what function user namespaces performs.
> "provide different user info" isn't a very useful description and
> I'd fix it if I understood what it is supposed to mean.

The pid namespaces are described here: http://lwn.net/Articles/259217/

> To make a guess at it, how about:
> 
>    Enable support for user namespaces.
> 
>    This is a function used by container-based virtualisation systems
>    (e.g. vservers). User namespaces ensures that processes with the
>    same uid which are in different containers are isolated from each other.
> 
>    Answer Y if you require container-based virtualisation like
>    vservers. If unsure, say N.

You'd better talk to Serge Hallyn (in Cc) about them. He had some
thoughts on how to complete them :)

> Nick.

