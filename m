Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZGUHZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZGUHZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZGUHZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:25:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47180 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZGUHZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:25:31 -0400
To: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       pazke@centrinvest.ru
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
From: Andi Kleen <andi@firstfloor.org>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
	<20090721065021.GC11781@centrinvest.ru>
Date: Tue, 21 Jul 2009 09:25:29 +0200
In-Reply-To: <20090721065021.GC11781@centrinvest.ru> (Andrey Panin's message of "Tue, 21 Jul 2009 10:50:21 +0400")
Message-ID: <87eisa33bq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrey Panin" <pazke@centrinvest.ru> writes:

Andrey, Your review would be easier to read if you removed the code
you're not commenting on.

>
> This inline function defined after being used. It's hard to tell whether gcc
> will actually inline it.

Near all supported gccs use "unit at a time" mode now and it's enabled,
so the order of functions in the file doesn't matter for inlining.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
