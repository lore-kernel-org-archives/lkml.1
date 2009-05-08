Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbZEHUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbZEHUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZEHUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZEHUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:16:19 -0400
Message-ID: <4A0492EA.6080403@zytor.com>
Date: Fri, 08 May 2009 13:15:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: improve e820_search_gap()
References: <4A0199B8.76EA.0078.0@novell.com> <4A03BC1A.9060605@zytor.com>	<4A03F016.76EA.0078.0@novell.com> <874ovvo0wo.fsf@basil.nowhere.org>
In-Reply-To: <874ovvo0wo.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Jan Beulich" <jbeulich@novell.com> writes:
>> Why blindly? Aren't hotpluggable memory ranges supposed to be reserved
>> in the E820 map?
> 
> They are supposed to be reserved in SRAT, but not in e820.

Ah, okay.  Perhaps we should fold this information into our internal 
"e820" map?  If so I guess the question is how soon we can do that.

	-hpa

