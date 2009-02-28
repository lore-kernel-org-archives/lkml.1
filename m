Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZB1Xgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZB1Xgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZB1Xgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:36:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZB1Xgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:36:31 -0500
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: Re: [PATCH] Input notifier support
From: Andi Kleen <andi@firstfloor.org>
References: <20090225044730.GA9106@july>
Date: Sun, 01 Mar 2009 00:34:38 +0100
In-Reply-To: <20090225044730.GA9106@july> (Kyungmin Park's message of "Wed, 25 Feb 2009 13:47:30 +0900")
Message-ID: <87skly16gh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

> Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
>
> So add input notifier and then use it at other frameworks such as led.
> Of course, other input device can use this one.
>
> Any commnets are welcome.

It looks like the perfect interface for a password stealing root kit.

Yes there are probably other ways to do this, but still this seems to
make it very easy.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
