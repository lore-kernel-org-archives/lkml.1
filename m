Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZLRP0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZLRP0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZLRP0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:26:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbZLRP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:26:11 -0500
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: spinlock which can morph into a mutex
From: Andi Kleen <andi@firstfloor.org>
References: <20091218143032.GA16595@xs4all.net>
Date: Fri, 18 Dec 2009 16:26:05 +0100
In-Reply-To: <20091218143032.GA16595@xs4all.net> (Miquel van Smoorenburg's message of "Fri, 18 Dec 2009 15:30:35 +0100")
Message-ID: <876384uwvm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miquel van Smoorenburg <miquels@cistron.nl> writes:
>
> So I probably need a mutex instead of a spinlock, but I want to
> keep minimal overhead for the common case (when no resizing is in
> progress).  I think I need a spinlock that can morph into a mutex ..

The standed mutexes already do that by themselves.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
