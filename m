Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab0CAQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:05:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab0CAQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:05:57 -0500
Date: Mon, 1 Mar 2010 08:05:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  - pci rom rom fail list
In-Reply-To: <4B8B0113.1020103@kernel.org>
Message-ID: <alpine.LFD.2.00.1003010803360.3616@localhost.localdomain>
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain> <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org> <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
 <4B8AF121.2060106@kernel.org> <4B8B0113.1020103@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Yinghai Lu wrote:
> 
> [PATCH] pci: don't reassign to ROM res if it is not going to be enabled
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Yes, this makes my setup work again.

I'm still nervous that it will cause problem on some _other_ machines 
(because of not knowing that some bridge is transparent and then trying to 
re-allocate things unnecessarily and causing chaos), but at least it seems 
to be ok on this machine.

So I do have this nagging feeling that we'll still end up having to do 
this whole "reassign PCI buses" thing as a kernel command line option and 
default to not doing it, but let's give it a chance.

		Linus
