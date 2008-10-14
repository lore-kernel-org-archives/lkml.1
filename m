Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYJNBme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYJNBme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYJNBmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:42:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:37632 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbYJNBmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:42:22 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
References: <20081014005428.EC2D8DDF93@ozlabs.org>
	 <48F3F014.3050406@zytor.com>
	 <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 12:41:58 +1100
Message-Id: <1223948518.8157.311.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> yes. some pci resource print out etc could use that too.
> to get rid of the annoying casting.
> 
> BTW: can you just enforce resource_t to u64?

Why the waste on embedded platforms that don't need it ?

Cheers,
Ben.


