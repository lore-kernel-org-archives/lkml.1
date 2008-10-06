Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYJFXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYJFXKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYJFXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:10:10 -0400
Received: from gw.goop.org ([64.81.55.164]:55894 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYJFXKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:10:09 -0400
Message-ID: <48EA9AC3.1050603@goop.org>
Date: Mon, 06 Oct 2008 16:09:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization
 a two pass sequence
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org>
In-Reply-To: <48EA798D.1090303@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> As it is, I suspect it will take a non-trivial amount of work to 
> restore Xen with this code in place (touching this code is always 
> non-trivial).  I haven't looked into it in depth yet, but there's a 
> few stand out "bad for Xen" pieces of code here.  (And I haven't 
> tested 32-bit yet.)

32-bit Xen is OK with this patch.  Reverting it restores 64-bit Xen.

    J
