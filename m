Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYHAS42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYHAS42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYHAS4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:56:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYHAS4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:56:19 -0400
Date: Fri, 1 Aug 2008 11:49:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on
 num_possible_cpus().
In-Reply-To: <20080801120455.GP9663@sgi.com>
Message-ID: <alpine.LFD.1.10.0808011149140.3277@nehalem.linux-foundation.org>
References: <20080731170022.GE9663@sgi.com> <m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com> <m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com> <m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Robin Holt wrote:
> 
> It was initially detected while profiling 'ps' on a 2048p machine that
> had 13 kernel threads per cpu.

Grr. Wouldn't it be better to concentrate on that "13 kernel threads per 
cpu" part?

		Linus
