Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYKWTqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYKWTqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYKWTpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:45:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46407 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbYKWTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:45:54 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Peter Teoh" <htmldeveloper@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: A question sort_main_extable()
From: Andi Kleen <andi@firstfloor.org>
References: <804dabb00811202142y799fb70dxf89a1fc3514d78b1@mail.gmail.com>
	<20081120214717.1a02a9af@infradead.org>
Date: Sun, 23 Nov 2008 20:45:57 +0100
In-Reply-To: <20081120214717.1a02a9af@infradead.org> (Arjan van de Ven's message of "Thu, 20 Nov 2008 21:47:17 -0800")
Message-ID: <87ej12i5u2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> we used to do this but it was a pain and extremely fragile. Runtime
> sorting makes it very robust at least.

It's not only extremly fragile, but just broken with out of line
section which gcc also generates these days.

>
> The sort is really quick though; I've spent a lot of time on boot time
> and this guy never showed up for me.

If you really wanted to speed it up you could actually just switch
over to a bubble sort. It's typically the best algorithm for nearly
already sorted input data, which this is.

But then as you say it's not worth it.

-Andi

-- 
ak@linux.intel.com
