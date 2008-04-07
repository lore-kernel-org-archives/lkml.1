Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYDGL7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYDGL7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYDGL7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:59:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYDGL7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:59:22 -0400
Date: Mon, 7 Apr 2008 14:03:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pavel Emelianov <xemul@openvz.org>,
       hugh@veritas.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Disable the memory controller by default
Message-ID: <20080407120340.GB16647@one.firstfloor.org>
References: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407115137.24124.59692.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 05:21:37PM +0530, Balbir Singh wrote:
> 
> 
> Due to the overhead of the memory controller. The
> memory controller is now disabled by default. This patch changes
> cgroup_disable to cgroup_toggle, so that each controller can decide
> whether it wants to be enabled/disabled by default.
> 
> If everyone agrees on this approach and likes it, should we push this
> into 2.6.25?

First I like the change to make it disabled by default.

I don't think "toggle" is good semantics for a user visible switch
because that changes the meaning when the kernel default changes
(which it will likely once the current default overhead is fixed)

It should be rather: cgroup=on/off 

-Andi
