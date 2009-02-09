Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZBIWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZBIWGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZBIWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:06:41 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:46688 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZBIWGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f4V+FKSD/VrETx+cGjQ4fclUt1b+ydZ/mS8kQwVc1eO7kSOvggnV/y/QcB1c+m8e3o
         8K1OBqOusIxnqbf9g7YQVsPqWlAgsAuaGNjWGP1KkMndbjmkW/+vCOv41eCyVxrg9iwP
         SIRml0o5zGvkyPVzp5s+PK9Kb/wU6iuKHNuDQ=
MIME-Version: 1.0
In-Reply-To: <1234214500.4175.255.camel@johannes.local>
References: <a44ae5cd0902091312t50f31689xe3bc56a25a0ff502@mail.gmail.com>
	 <1234214500.4175.255.camel@johannes.local>
Date: Mon, 9 Feb 2009 17:06:39 -0500
Message-ID: <a44ae5cd0902091406m68702443h873500e89dc1fcd1@mail.gmail.com>
Subject: Re: 2.6.29-rc4-git1 -- iwl3945: Can not allocate SKB buffers
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 4:21 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-09 at 16:12 -0500, Miles Lane wrote:
>> [12506.627936] iwl3945: Can not allocate SKB buffers
>
> So iwl3945 prints out that it's out of memory, but probably uses
> __GFP_NOWARN.
>
>> [12544.530789] java: page allocation failure. order:1, mode:0x4020
>> [12544.530798] Pid: 21292, comm: java Not tainted 2.6.29-rc4-git1 #2
>> [12544.530801] Call Trace:
>> [12544.530812]  [<ffffffff8028f12d>] __alloc_pages_internal+0x423/0x442
>> [12544.530820]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
>> [12544.530826]  [<ffffffff802b13df>] alloc_slab_page+0x20/0x26
>> [12544.530830]  [<ffffffff802b1624>] __slab_alloc+0x23f/0x527
>> [12544.530835]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
>> [12544.530839]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
>> [12544.530844]  [<ffffffff802b23db>] __kmalloc+0xbc/0x102
>> [12544.530848]  [<ffffffff804cbb4f>] pskb_expand_head+0x52/0x16f
>> [12544.530854]  [<ffffffff805a0c8b>] ieee80211_skb_resize+0x91/0xca
>> [12544.530858]  [<ffffffff805a16fd>] ieee80211_master_start_xmit+0x260/0x4c3
>
> and here we have pskb_expand_head failing to allocate memory. And an
> order 1 allocation too. Are you saying wireless has a memory leak?

I can't say.  I am just testing the development tree.  I believe this error
occurred while I was running Azureus (the java-based torrent client).
I can try to reproduce the problem, but I don't know how to debug it.

    Miles
