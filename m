Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYDTTK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYDTTK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYDTTKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:10:21 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:9393 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbYDTTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:10:20 -0400
To: David <david@unsolicited.net>
Cc: casey@schaufler-ca.com, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 Kernel - Problems with capabilities
From: Andi Kleen <andi@firstfloor.org>
References: <46016.36939.qm@web36608.mail.mud.yahoo.com>
	<480B7D72.7020503@unsolicited.net>
Date: Sun, 20 Apr 2008 21:08:18 +0200
In-Reply-To: <480B7D72.7020503@unsolicited.net> (david@unsolicited.net's message of "Sun, 20 Apr 2008 18:29:22 +0100")
Message-ID: <87y7788hul.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 19:01:29.0893 (UTC) FILETIME=[F10F8D50:01C8A318]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David <david@unsolicited.net> writes:

> Casey Schaufler wrote:
>> Do you have a libcap that reflects the change from 32 capabilities
>> to 64? You'll be looking for libcap.so.2.06 or thereabouts.
>>
> Adding libcap-2.08 and recompiling ntpd has fixed the issue, and I'm
> now running normally, thanks!

FWIW I ran into this problem too with systemtap. It was a quite 
nasty surprise and took some time to track down.

I also don't remember seeing a thread about this on l-k.  Where was this
major binary breakage discussed?

-Andi

