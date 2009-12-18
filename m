Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZLRVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZLRVQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbZLRVQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:16:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932726AbZLRVQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:16:12 -0500
Date: Fri, 18 Dec 2009 13:15:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/12] pci: separate pci_setup_bridge to small functions
In-Reply-To: <4B2BEC16.5060203@kernel.org>
Message-ID: <alpine.LFD.2.00.0912181314090.3712@localhost.localdomain>
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC16.5060203@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Yinghai Lu wrote:
> 
> prepare to use those small functions according to resource type later
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Ack. looks like a nice cleanup regardless of anything else. I much prefer 
having lots of small functions that do one thing and one thing only, and 
then one function that is there just to call them.

		Linus
