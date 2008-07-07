Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbYGGUzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbYGGUzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 16:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbYGGUzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 16:55:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYGGUzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 16:55:25 -0400
Date: Mon, 7 Jul 2008 16:53:42 -0400
From: Bill Nottingham <notting@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Cc: bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] Allow full bridge configuration via sysfs
Message-ID: <20080707205342.GA19710@nostromo.devel.redhat.com>
Mail-Followup-To: Patrick McHardy <kaber@trash.net>,
	bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
References: <cover.1215460681.git.notting@redhat.com> <4872819E.3040604@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4872819E.3040604@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy (kaber@trash.net) said: 
> Bill Nottingham wrote:
>> Right now, you can configure most bridge device parameters via sysfs.
>> However, you cannot either:
>> - add or remove bridge interfaces
>> - add or remove physical interfaces from a bridge
>>
>> The attached patch set rectifies this. With this patch set, brctl
>> (theoretically) becomes completely optional, much like ifenslave is
>> now for bonding. (In fact, the idea for this patch, and the syntax
>> used herein, is inspired by the sysfs bonding configuration.)
>
> Both should use netlink instead of extending their sysfs interfaces.
> For bridging I have a patch for the bridge device itself, the API
> is so far missing support for adding ports though.

How does that improve the situation for bridge devices? Are all
bridging parameters (forward_delay, stp, etc.) going to be configurable
via netlink, or would we still then have multiple tools/interfaces
to configuration? Also, moving bonding configuration to netlink seems
like a step backwards.

Bill
