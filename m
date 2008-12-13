Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbYLMRQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbYLMRQm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLMRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:16:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYLMRQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:16:34 -0500
Date: Sat, 13 Dec 2008 09:16:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
cc: matthew@wil.cx, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: PCI BAR mem resource allocation "regression"
In-Reply-To: <20081213000538.GC9947@ldl.fc.hp.com>
Message-ID: <alpine.LFD.2.00.0812130901370.3340@localhost.localdomain>
References: <20081213000538.GC9947@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Dec 2008, Alex Chiang wrote:
> 
> I've been chasing a bug for the past week or so that I can't seem
> to figure out, and was hoping to get your eyes on it.
> 
> The basic summary is, we can't allocate a memory resource for our
> BAR after a PCI hotplug operation. We've been able to bisect it
> down to d33b6fba2c4350651f3f61ff2ab858a2f116e9a4 (Resources:
> insert identical resources above existing resources).

I'm missing some pieces I'd like to see: /proc/iomem before and after, and 
lspci output before and after (you do give lspci output, but only one, and 
I can't tell if it's before or after).

Also, is it just the error message, or does it actually affect 
functionality?

			Linus
