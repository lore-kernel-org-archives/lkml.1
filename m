Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbYBKT20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbYBKT20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbYBKT2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:28:18 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:59329 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYBKT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:28:17 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc0 (#2)
Date: Mon, 11 Feb 2008 19:23:30 +0000
User-Agent: KMail/1.9.7
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200802080145.16774.lenb@kernel.org> <200802091142.18596.carlos@strangeworlds.co.uk> <20080211091743.GA16459@elte.hu>
In-Reply-To: <20080211091743.GA16459@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111923.31736.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 11 Feb 2008 19:23:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 09:17:43 Ingo Molnar wrote:
> no, it does not help - see the attached .config and the crash.log.

Thanks Ingo - the cause of the crash is ACPI being disabled on your system for 
some reason. I can reproduce your crash every time here with acpi=off.

The two WMI based drivers (acer-wmi, tc1100-wmi) in the kernel both need a 
simple patch each to fix this - patches to follow.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
