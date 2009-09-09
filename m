Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZIIABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZIIABR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZIIABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:01:17 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:45688 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZIIABQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:01:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 9DB683CA1F8
Message-ID: <4AA6F04D.4020605@arcor.de>
Date: Wed, 09 Sep 2009 03:01:17 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [long] Another BFS versus CFS shakedown
References: <200909090142.41738.elendil@planet.nl>
In-Reply-To: <200909090142.41738.elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 02:42 AM, Frans Pop wrote:
> But this evening, while I was preparing and running the tests, I've had 4
> freezes of the desktop.

Unfortunately BFS doesn't provide a reliable way (yet?) to run such 
tests on it.  This might be the cause for the hangs (from bfs-faq.txt):

   Currently known problems?
   [...]
   3. Stuck tasks after extensive use of trace functions
   (ptrace etc.).
   [...]
   5. More likely to show up bugs in *other* code due to
   being much more aggressive at using multiple CPUs so
   race conditions will show up more frequently.
