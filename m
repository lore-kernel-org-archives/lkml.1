Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYHRGJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYHRGJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYHRGJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:09:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYHRGJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:09:14 -0400
To: "Marc Villemade" <mastachand@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Follow-up] Physical memory disappeared from /proc/meminfo
From: Andi Kleen <andi@firstfloor.org>
References: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com>
Date: Mon, 18 Aug 2008 08:09:11 +0200
In-Reply-To: <f2b895370808171059x4bd0296frf50b07ae7af21375@mail.gmail.com> (Marc Villemade's message of "Sun, 17 Aug 2008 19:59:10 +0200")
Message-ID: <87od3q26t4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Marc Villemade" <mastachand@gmail.com> writes:
>
> I'm having exactly the same issue but on a 2.6.20.4 vanilla kernel
> (x86). /proc/meminfo shows that
> MemFree+Buffers+cached+AnonPages+Slab+Mapped != MemTotal, which AFAIK
> should be the case.

Nope, the equation is not necessarily true. 
See http://halobates.de/memorywaste.pdf for a detailed discussion.

-Andi
