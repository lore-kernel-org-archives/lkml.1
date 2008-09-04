Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYIDMBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYIDMBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIDMBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:01:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60390 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYIDMBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:01:47 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
From: Andi Kleen <andi@firstfloor.org>
References: <20080903195122.73905236@infradead.org>
Date: Thu, 04 Sep 2008 14:01:46 +0200
In-Reply-To: <20080903195122.73905236@infradead.org> (Arjan van de Ven's message of "Wed, 3 Sep 2008 19:51:22 -0700")
Message-ID: <873akgw251.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> Add basic sanity checks to the syscall execution patch

This just means that the root kits will switch to patch
the first instruction of the entry points instead.

So the protection will be zero to minimal, but the overhead will
be there forever.

Now that I said this I expect it to go in yesterday.

-Andi

