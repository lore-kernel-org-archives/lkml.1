Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYFOSfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYFOSfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYFOSfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:35:11 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:64463 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbYFOSfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:35:10 -0400
Date: Sun, 15 Jun 2008 20:31:49 +0200
Message-Id: <317948575@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, kernel-testers@vger.kernel.org
Subject: suse slab testing module "crasher"
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/99BVJd0ZshbD+iFeiIcjuK7YzOI0Plp/rMsnPD4QyX94+v
 KEcN3UFvF+0yTjD9piQAQPCc5V9wlxFOJy9WAR0Gf7vybWgpJI=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Andrew Morton <akpm@linux-foundation.org> writes:
>>
>> Doing the same thing on 2.6.26-rc5-mm3, msgctl08 also runs to
>> completion, in 20.9 seconds.  So
>>
>> - it got slower
>
>That is because it scales itself to the number of available msg queues.
>So with Nadia's patch there are more and it runs slower.
>
>In fact it seems to start one process per message queue, so perhaps it's 
>just running out of processes or something. Ok it should not segfault.
>
>BTW a great way to debug slab corruptions with LTP faster is to run with
>a slab thrasher stress module like http://firstfloor.org/~andi/crasher-26.diff
>
>-Andi

any reason why only suse has this, but not mainline ?

i came across that module in suse kernel just some days ago and asked novell ( https://bugzilla.novell.com/show_bug.cgi?id=396132 ) , but they don`t have any objections.
chris mason didn`t reply on direct request....

so, if it`s useful, who is reponsible for pushing it upstream ?

______________________________________________________________
Jeden Monat 1 hochkarätiger maxdome-Blockbuster GRATIS!
Exklusiv für alle WEB.DE Nutzer. http://www.blockbuster.web.de

