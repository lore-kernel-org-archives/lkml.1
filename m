Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZFVS6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZFVS6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZFVS6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:58:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbZFVS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:58:45 -0400
Date: Mon, 22 Jun 2009 11:56:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bernd Schmidt <bernds_cb1@t-online.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
In-Reply-To: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906221153290.3240@localhost.localdomain>
References: <4A3F5EAE.7020402@t-online.de> <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Jun 2009, Linus Torvalds wrote:
> 
> I applied this patch, but I want to just vent my frustration with it.

Actually, I take that back. I applied it by hand, but then unapplied it, 
because the patch also had

		res = load_flat_file(&bprm, libs, id, NULL, NULL);

when my tree only has one "NULL", and always has had. So I'm not sure what 
this is even based on.

		Linus
