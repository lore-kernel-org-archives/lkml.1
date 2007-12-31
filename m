Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXLaCj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXLaCj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 21:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXLaCjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 21:39:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:58252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXLaCjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 21:39:16 -0500
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: numa_default_policy()
From: Andi Kleen <andi@firstfloor.org>
References: <86802c440712301756m3b450a31l8b3569000e1f7b2b@mail.gmail.com>
Date: Mon, 31 Dec 2007 03:39:15 +0100
In-Reply-To: <86802c440712301756m3b450a31l8b3569000e1f7b2b@mail.gmail.com> (Yinghai Lu's message of "Sun\, 30 Dec 2007 17\:56\:08 -0800")
Message-ID: <p73wsqvziy4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> it seems in numa_default_policy()
>
> are called two times:
>
> one is in rest_init(), and another is init_post()
>
> another reason for that?

They run in different threads.

-Andi
