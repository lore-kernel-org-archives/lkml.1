Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJNBTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJNBTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYJNBTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:19:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbYJNBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:19:33 -0400
Message-ID: <48F3F2E0.4050904@zytor.com>
Date: Mon, 13 Oct 2008 18:16:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <20081014005428.EC2D8DDF93@ozlabs.org> <48F3F014.3050406@zytor.com> <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
In-Reply-To: <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> yes. some pci resource print out etc could use that too.
> to get rid of the annoying casting.
> 
> BTW: can you just enforce resource_t to u64?
> 

We definitely shouldn't.  It'd suck on embedded systems.

	-hpa
