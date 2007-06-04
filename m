Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXFDWyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXFDWyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbXFDWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:54:37 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:55101 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762600AbXFDWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:54:36 -0400
Date: Mon, 4 Jun 2007 18:54:33 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Paul Moore <paul.moore@hp.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       "Christopher J. PeBenito" <cpebenito@tresys.com>,
       Joshua Brindle <method@manicmethod.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [bug] very high non-preempt latency in context_struct_compute_av()
In-Reply-To: <200706041848.21306.paul.moore@hp.com>
Message-ID: <Line.LNX.4.64.0706041853210.14560@d.namei>
References: <20070604112745.GA26350@elte.hu> <200706041711.42755.paul.moore@hp.com>
 <1180993140.14220.168.camel@moss-spartans.epoch.ncsc.mil>
 <200706041848.21306.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Paul Moore wrote:

> Okay, for some reason I thought someone had found a way to make 
> RCU "preemptable" through the real-time work, maybe I'm just confused 
> again :)

It is preemptible in the RT kernel, but as Ingo points out, nothing should 
be even trying to do something for 130ms in the kernel.


- James
-- 
James Morris
<jmorris@namei.org>
