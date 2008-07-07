Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYGGU7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYGGU7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYGGU6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:58:54 -0400
Received: from stinky.trash.net ([213.144.137.162]:38340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbYGGU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:58:54 -0400
Message-ID: <4872838B.1060603@trash.net>
Date: Mon, 07 Jul 2008 22:58:51 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] Allow full bridge configuration via sysfs
References: <cover.1215460681.git.notting@redhat.com> <4872819E.3040604@trash.net> <20080707205342.GA19710@nostromo.devel.redhat.com>
In-Reply-To: <20080707205342.GA19710@nostromo.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Nottingham wrote:
> Patrick McHardy (kaber@trash.net) said: 
>> Bill Nottingham wrote:
>>> Right now, you can configure most bridge device parameters via sysfs.
>>> However, you cannot either:
>>> - add or remove bridge interfaces
>>> - add or remove physical interfaces from a bridge
>>>
>>> The attached patch set rectifies this. With this patch set, brctl
>>> (theoretically) becomes completely optional, much like ifenslave is
>>> now for bonding. (In fact, the idea for this patch, and the syntax
>>> used herein, is inspired by the sysfs bonding configuration.)
>> Both should use netlink instead of extending their sysfs interfaces.
>> For bridging I have a patch for the bridge device itself, the API
>> is so far missing support for adding ports though.
> 
> How does that improve the situation for bridge devices? Are all
> bridging parameters (forward_delay, stp, etc.) going to be configurable
> via netlink, or would we still then have multiple tools/interfaces
> to configuration?

Of course its all going to be configurable via netlink, otherwise
it really wouldn't make sense.

> Also, moving bonding configuration to netlink seems
> like a step backwards.

Please read up on what the standard interface for network
configuration is, I'm tired of reiterating this once a week.
