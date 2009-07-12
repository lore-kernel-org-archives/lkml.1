Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZGLIvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZGLIvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZGLIvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:51:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52455 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZGLIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:51:37 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com,
       Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [FIX REQUEST] Need better management for include/linux/*.h
From: Andi Kleen <andi@firstfloor.org>
References: <1247303928.2678.46.camel@ht.satnam>
Date: Sun, 12 Jul 2009 10:51:31 +0200
In-Reply-To: <1247303928.2678.46.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Sat, 11 Jul 2009 14:48:48 +0530")
Message-ID: <87ws6e9td8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> Hello all,
>
> As include/linux/*.h file count is going to reach 1000.
>
> We need to do some better techniques to reduce the number of files and
> add some hierarchy levels like sub directories where possible.

Why? 100 or 1000 really doesn't make much difference; in both
cases you cannot easily browse and have to use tab completion.
And I doubt your reorganization would go below 100.

I would just leave it as it is.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
