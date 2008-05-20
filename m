Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbYETLt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbYETLt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYETLtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:49:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYETLtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:49:17 -0400
Message-ID: <4832BABA.9040809@firstfloor.org>
Date: Tue, 20 May 2008 13:49:14 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <87k5hpgqwa.fsf@basil.nowhere.org> <4832B74F.5040402@qumranet.com>
In-Reply-To: <4832B74F.5040402@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Makes sense.  I'll send out v3.
> 
> Is there a similar range on i386?

Don't think so. Address space is too precious here.

What you could probably do is to unmap one fixed page in some range
that is always split to 4K pages anyways and use that. Perhaps somewhere
in the 640k-1MB range. But if you're unlucky this might require a
variable, not a constant.

-Andi
