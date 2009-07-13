Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZGMJJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZGMJJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGMJJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:09:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZGMJJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:09:30 -0400
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Counters in df, du
From: Andi Kleen <andi@firstfloor.org>
References: <20090713081106.GA5569@beaver.vrungel.ru>
Date: Mon, 13 Jul 2009 11:09:29 +0200
In-Reply-To: <20090713081106.GA5569@beaver.vrungel.ru> (Alexey Vlasov's message of "Mon, 13 Jul 2009 12:11:06 +0400")
Message-ID: <87fxd19cfq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Vlasov <renton@renton.name> writes:
>
> I know that df, du can show different values if some files were deleted,
> but the processes which opened these files are still acting.

You can check for that by doing ls -l /proc/*/fd | grep deleted

It won't tell you the file size though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
