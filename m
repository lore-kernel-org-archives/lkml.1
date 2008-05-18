Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYERUEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYERUEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYERUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:04:25 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35556 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYERUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:04:24 -0400
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
From: Andi Kleen <andi@firstfloor.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
	<482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
	<482E08E6.4030507@redhat.com>
Date: Sun, 18 May 2008 22:03:55 +0200
In-Reply-To: <482E08E6.4030507@redhat.com> (Eric Sandeen's message of "Fri, 16 May 2008 17:21:26 -0500")
Message-ID: <8763tbcrbo.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 May 2008 19:56:59.0121 (UTC) FILETIME=[55006E10:01C8B921]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:
>
> Right, that was the plan.  I wasn't really going to stand there and pull
> the plug.  :)  I'd like to get to "out of $NUMBER power-loss events
> under this usage, I saw $THIS corruption $THISMANY times ..."

I'm not sure how good such exact numbers would do. Surely power down
behaviour that would depend on the exact disk/controller/system
combination? Some might be better at getting data out at 
power less, some might be worse.

To get a good picture, you would probably need to do such tests
over a wide range of systems and put all the data together, but
even then you couldn't be sure you covered all well.

For a distributor it would probably make more sense to do such
tests as part of system certification and then modify the defaults
to match all tested systems. But that doesn't really work
for good mainline defaults.

I suspect for mainline the only good default is to be very conservative.

-Andi
