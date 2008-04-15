Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYDOKkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYDOKkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYDOKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:40:01 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:20496 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYDOKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:40:00 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: mm/page_alloc.c: remove hand-coded get_order()
From: Andi Kleen <andi@firstfloor.org>
References: <20080415092317.GA1529@elf.ucw.cz>
Date: Tue, 15 Apr 2008 12:39:27 +0200
In-Reply-To: <20080415092317.GA1529@elf.ucw.cz> (Pavel Machek's message of "Tue, 15 Apr 2008 11:23:27 +0200")
Message-ID: <87ej97tna8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Apr 2008 10:32:41.0782 (UTC) FILETIME=[08D2BD60:01C89EE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:
>
> What about creating void *get_free_pages(flags, order) version, then
> slowly converting users to it?

Then we would also need a free_pages() that takes void *, but unfortunately
free_pages() already has other semantics.

-Andi
