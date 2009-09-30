Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZI3Ojz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZI3Ojz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZI3Ojy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:39:54 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:54133 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753304AbZI3Ojx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:39:53 -0400
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>
From: Dan Smith <danms@us.ibm.com>
Date: Wed, 30 Sep 2009 07:39:44 -0700
In-Reply-To: <4AC20BB8.4070509@free.fr> (Daniel Lezcano's message of "Tue\, 29 Sep 2009 15\:29\:28 +0200")
Message-ID: <87iqf0o5sf.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DL> Ok for the restart, but for the checkpoint, how do you access the
DL> network setup from a process which belongs to another namespace
DL> context ?

So far the discussion has led to the kernel dumping all of that
information on checkpoint, and then splitting it up into what can be
done by userspace on restart and what still needs to be in the kernel.

Similarly, the task structure is currently exported by the kernel on
checkpoint, but recreated in userspace on restart.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com
