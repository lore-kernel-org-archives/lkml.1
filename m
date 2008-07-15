Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYGOLvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYGOLvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 07:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYGOLvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 07:51:35 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:52347 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYGOLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 07:51:34 -0400
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo
	sched domain managment (take 2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <1216122577.27242.57.camel@violet.holtmann.net>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
	 <1216122577.27242.57.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:52:00 +0200
Message-Id: <1216122720.12595.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:49 +0200, Marcel Holtmann wrote:
> Hi Max,
> 
> >   *  #ifdef CONFIG_HOTPLUG_CPU
> >   *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
> >   *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
> >   *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
> > + *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
> 
> why not just fixing all spelling mistakes instead of keeping them
> around ;)

What spelling mistakes?

