Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbXGKK7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbXGKK7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758842AbXGKK7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:59:00 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:60058 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXGKK67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:58:59 -0400
Message-ID: <4694B7EF.6040606@grupopie.com>
Date: Wed, 11 Jul 2007 11:58:55 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc6-mm1] kallsyms: make KSYM_NAME_LEN include space
 for trailing '\0'
References: <20070711094429.GD23568@htj.dyndns.org>
In-Reply-To: <20070711094429.GD23568@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> KSYM_NAME_LEN is peculiar in that it does not include the space for
> the trailing '\0', forcing all users to use KSYM_NAME_LEN + 1 when
> allocating buffer.  This is nonsense and error-prone.  Moreover, when
> the caller forgets that it's very likely to subtly bite back by
> corrupting the stack because the last position of the buffer is always
> cleared to zero.
> 
> This patch increments KSYM_NAME_LEN by one and updates code
> accordingly.

Nice work.

I've been wanting to do that cleanup myself for a long time ;)

Acked-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"You're just jealous because the voices only talk to me."
