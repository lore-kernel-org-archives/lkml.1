Return-Path: <linux-kernel-owner+w=401wt.eu-S1764009AbZEHTWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764009AbZEHTWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZEHTWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:22:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51023 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZEHTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:22:16 -0400
To: "Jan Beulich" <jbeulich@novell.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
From: Andi Kleen <andi@firstfloor.org>
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com>
	<4A03F016.76EA.0078.0@novell.com>
Date: Fri, 08 May 2009 21:22:15 +0200
In-Reply-To: <4A03F016.76EA.0078.0@novell.com> (Jan Beulich's message of "Fri, 08 May 2009 07:40:54 +0100")
Message-ID: <874ovvo0wo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:
>
> Why blindly? Aren't hotpluggable memory ranges supposed to be reserved
> in the E820 map?

They are supposed to be reserved in SRAT, but not in e820.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
