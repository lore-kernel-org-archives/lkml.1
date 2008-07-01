Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYGASiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYGASiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYGASim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:38:42 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:54667 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYGASil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:38:41 -0400
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: small unifications of address printing
From: Andi Kleen <andi@firstfloor.org>
References: <20080701155217.GA22318@damson.getinternet.no>
Date: Tue, 01 Jul 2008 20:29:54 +0200
In-Reply-To: <20080701155217.GA22318@damson.getinternet.no> (Vegard Nossum's message of "Tue, 1 Jul 2008 17:52:17 +0200")
Message-ID: <87d4lxtq3h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 18:22:33.0792 (UTC) FILETIME=[6E60D400:01C8DBA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> writes:

> 'man 3 printf' tells me that %p should be printed as if by %#x, but
> this is not true for the kernel, which does not use the '0x' prefix
> for the %p conversion specifier.

Problem is that %p will not pad to 8/16 digits. Addresses are traditionally
padded.

-Andi
