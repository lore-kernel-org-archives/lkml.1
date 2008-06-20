Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYFTQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYFTQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYFTQvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 12:51:05 -0400
Received: from webmail.e-teleport.net ([213.190.83.68]:40015 "EHLO
	mail.imsnet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYFTQvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:51:03 -0400
Message-ID: <485BDFEF.2090307@e-teleport.net>
Date: Fri, 20 Jun 2008 18:50:55 +0200
From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, alan@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-velocity.c fix sleep-with-spinlock bug during
 MTU change
References: <20080604215909.GA17446@electric-eye.fr.zoreil.com> <20080614212341.GA12976@electric-eye.fr.zoreil.com> <4856DA62.7080803@e-teleport.net> <20080617214538.GA6388@electric-eye.fr.zoreil.com> <48584AA4.8040801@e-teleport.net> <48593E35.1010409@e-teleport.net> <20080618201012.GA4019@electric-eye.fr.zoreil.com> <48598784.40306@e-teleport.net> <20080619204312.GA2160@electric-eye.fr.zoreil.com> <485B8542.7060204@e-teleport.net> <20080620103910.GA21227@electric-eye.fr.zoreil.com>
In-Reply-To: <20080620103910.GA21227@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu a écrit :
> Séguier Régis <rseguier@e-teleport.net> :
> [...]
>   
>> But if I generate a paquet with a size more than around 3825, the driver 
>> don't send it and no paquet is send after, work again after an interface 
>> down/up and until no paquet > 3825.
>>     
>
> Does it qualify as a regression ?
>
>   
I couldn't say yes now.

To be honest, I never test mtu > 1500 with this driver before.

This can be detected before with the difficulty of mtu change?

I'll test the driver before patch with a bigger MTU. (i'll try to do 
this next week)

-- 
Régis
