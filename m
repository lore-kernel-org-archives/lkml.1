Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXGBW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXGBW4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXGBW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:56:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbXGBW4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:56:01 -0400
Message-ID: <4689826C.5050800@redhat.com>
Date: Mon, 02 Jul 2007 18:55:40 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@gmail.com>, Andy Isaacson <adi@hexapodia.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>  <20070629193954.GL9157@hexapodia.org>  <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>  <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>  <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>  <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>  <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>  <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>  <20070702190043.GN9157@hexapodia.org> <46894BE6.1040302@redhat.com> <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com> <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Mon, 2 Jul 2007, Ulrich Drepper wrote:
> 
>> On 7/2/07, Rik van Riel <riel@redhat.com> wrote:
>>> That should not happen.  The default SELinux configuration
>>> in Fedora (and Debian?) runs a few daemons in their own
>>> restricted modes and has most of the system running in
>>> unconfined_t, including the majority of user programs.
>> This is the state as of F7.  This will change hopefully soon.
>> Programs like firefox run by normal users must be confined, to. Any
>> tests using security must be fast, it's not something which is done
>> only for a few apps.
> 
> The strong requirement would be that the cookie is not a bit longer than 
> sizeof(unsigned long).

You could easily replace the cookie with a pointer to a free
page pool.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
