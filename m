Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYGOL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYGOL5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYGOL5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:57:41 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59825 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbYGOL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:57:41 -0400
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
	sched domain managment (take 2)
From: Marcel Holtmann <marcel@holtmann.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <1216122720.12595.173.camel@twins>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
	 <1216122577.27242.57.camel@violet.holtmann.net>
	 <1216122720.12595.173.camel@twins>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:57:48 +0200
Message-Id: <1216123068.27242.60.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > >   *  #ifdef CONFIG_HOTPLUG_CPU
> > >   *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
> > >   *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
> > >   *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
> > > + *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
> > 
> > why not just fixing all spelling mistakes instead of keeping them
> > around ;)
> 
> What spelling mistakes?

so it wasn't meant to say "... if cpu ..." and I simply miss something
here (which is possible)?

Regards

Marcel


