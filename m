Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYGKR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYGKR7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGKR7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:59:06 -0400
Received: from gw.goop.org ([64.81.55.164]:50456 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbYGKR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:59:05 -0400
Message-ID: <48779F5A.9070502@goop.org>
Date: Fri, 11 Jul 2008 10:58:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] x86: fix savesegment() bug causing crashes on 64-bit
References: <20080711175002.GA32116@elte.hu>
In-Reply-To: <20080711175002.GA32116@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>     
> i spent a fair amount of time chasing a 64-bit bootup crash in 
> tip/master that manifested itself as bootup segfaults:
>   

Crap, I'm sorry.  I fixed this locally a couple of days ago, but I 
hadn't actually observed it causing any problems, so I didn't rush to 
push it out.

> The solution is to only allow segment operands to go to registers. This 
> fix allows my test-system to boot up without crashing.
>     
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>   

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
