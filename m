Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbZGIMiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbZGIMiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbZGIMiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:38:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbZGIMh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:37:59 -0400
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/18] periodic write-back timer optimization
From: Andi Kleen <andi@firstfloor.org>
References: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Date: Thu, 09 Jul 2009 14:37:57 +0200
In-Reply-To: <20090709084822.12122.79749.sendpatchset@localhost.localdomain> (Artem Bityutskiy's message of "Thu, 09 Jul 2009 11:48:22 +0300")
Message-ID: <871voq6nh6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <Artem.Bityutskiy@nokia.com> writes:

>
> The patches attempt to optimize the periodic write-back and stop it when
> there are no dirty data. IOW, we do not want the thread to wake up every
> 5 seconds (by default), find there is nothing to do, and so on.

Is waking up every 5 seconds really a problem?

The normal rule of thumb is iirc that longer sleep times than a few hundred
ms give dimishing returns in terms of power saving.

A simple way might be simple to batch the timer better with other timers.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
