Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYGAS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYGAS6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYGAS6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:58:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44175 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYGAS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:58:07 -0400
Message-ID: <486A7E3D.3050901@firstfloor.org>
Date: Tue, 01 Jul 2008 20:58:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: small unifications of address printing
References: <20080701155217.GA22318@damson.getinternet.no>	 <87d4lxtq3h.fsf@basil.nowhere.org> <19f34abd0807011146g2bb8baf0q2dbaa9ebe501657e@mail.gmail.com>
In-Reply-To: <19f34abd0807011146g2bb8baf0q2dbaa9ebe501657e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, it will, and correctly too:
> 
>         case 'p':
>                 flags |= SMALL;
>                 if (field_width == -1) {
>                         field_width = 2*sizeof(void *);
>                         flags |= ZEROPAD;
>                 }
> 
> Or did I read this code wrong? field_width is initialized to -1 by
> default unless overridden. The SMALL flag means lowercase hexadecimal
> digits.

You're right. The kernel differs from user space/traditional behaviour
in this regard.

-Andi
