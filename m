Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYKKSxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYKKSxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbYKKSxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:53:39 -0500
Received: from gw.goop.org ([64.81.55.164]:53931 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYKKSxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:53:39 -0500
Message-ID: <4919D4B1.7080703@goop.org>
Date: Tue, 11 Nov 2008 10:53:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Status of Xen in vanilla?
References: <20081111113838.GA3474@outback.rfc2324.org>
In-Reply-To: <20081111113838.GA3474@outback.rfc2324.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maximilian Wilhelm wrote:
> Hi!
>
> I'm wondering about the status of Xen support in the vanilla kernel.
> I know that DomU support is inside the kernel an evolving, but I did
> not find an up-to-date hint about the status of Dom0 support.
>
> A while ago I read that it should be included in 2.6.28, but I do not
> find any current pointer about the status of this.
>   

.28 was a bit optimistic; .29 seems reasonable.  The current dom0 kernel 
patches can boot up to a fully functional dom0 usersmode, and you can 
start xend to see that domain 0 is running.  I *think* in theory you can 
create a deviceless domain, but I haven't tried it.  I'm currently 
working on blktap support.

I really need to put together a proper status update.  Now that dom0 
usermode is working, its a much better base for other people start 
contributing.

    J
