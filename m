Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZI3Q3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZI3Q3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZI3Q3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:29:23 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:54407 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbZI3Q3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:29:23 -0400
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>
	<87iqf0o5sf.fsf@caffeine.danplanet.com> <4AC38477.4070007@free.fr>
From: Dan Smith <danms@us.ibm.com>
Date: Wed, 30 Sep 2009 09:29:23 -0700
In-Reply-To: <4AC38477.4070007@free.fr> (Daniel Lezcano's message of "Wed\, 30 Sep 2009 18\:16\:55 +0200")
Message-ID: <87eipoo0po.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DL> If the checkpoint is done from the kernel, why the restart
DL> wouldn't be in the kernel too ?

I think thus far we have taken the approach of "if it can be done
reasonably in userspace, then do it there" right?  Setup of the
network devices is easy to do in userspace, allows more flexibility
from a policy standpoint, and ensures that all existing security
checks are performed.  Also, migration may be easier if the userspace
bits can call custom hooks allowing for routing changes and other
infrastructure-specific operations.

DL> Is there any documentation about the statefile format I can use if
DL> I want to implement myself an userspace CR solution based on this
DL> kernel patchset ?

See linux-cr/include/linux/checkpoint_hdr.h and user-cr/restart.c.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
