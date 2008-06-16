Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYFPPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYFPPp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYFPPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:45:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYFPPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:45:13 -0400
Message-ID: <48568A69.6040800@zytor.com>
Date: Mon, 16 Jun 2008 08:44:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com> <20080616080131.GC25632@elte.hu>
In-Reply-To: <20080616080131.GC25632@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> hm. Why dont we instead add the size of the hole to the 
> __VMALLOC_RESERVE value instead? There's nothing inherently bad about 
> using vmalloc=16m. The VM area hole is really a kernel-internal 
> abstraction that should not be visible in the usage of the parameter.
> 

Well, the question is are we taking it away from RAM or away from 
vmalloc... there aren't really any other alternatives.

	-hpa
