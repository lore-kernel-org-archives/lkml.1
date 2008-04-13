Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbYDMMsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbYDMMsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYDMMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:48:27 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:54247 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYDMMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:48:26 -0400
Date: Sun, 13 Apr 2008 14:45:18 +0200
Message-Id: <237143435@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: cebbert@redhat.com, hidave.darkstar@gmail.com, jeremy@goop.org
Subject: netsc520 - skeleton in the closet ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18SlDvGxdkx3roUjvrVCo9qdv60ZultC09BX8wcqnXM9KwKI
 OlcnQHOxqqfsZv6RKOJlgwrlmqaUdD9GenomwBd3jXGxyGHmkQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i'm doing some module testing from time to time and i'm somewhat sure, that there is an issue with netsc520 module, as i have seen more than one occasion that after load/unloading of that module (w/o presence of the appropriate hw), other modules had issues.

see http://marc.info/?l=linux-kernel&m=120664963508105&w=2 for example.

now,by chance i came across this one: http://marc.info/?l=linux-kernel&m=118274309325836&w=2

>> > >> netsc520 is doing iounmap() of an area it did
>> > >> ioremap_nocache() on earlier, because it has now failed to
>> > >> find a device. Why it went BUG() I have no idea.
>> > >>
>> > >
>> > > Hi, maybe some config option cause this issue, here is my current
>> > > working-ok config file:
>> >
>> > What are the differences from the non-working config?
>> >
>> >     J
>> >
>> The diffrences is net520c item.
>>
>sorry it is netsc520, I will post the patch after a while.

so, it sounds there is a known issue with netsc520, but i'm not sure if it's the related and if that mentioned patch has been posted, at least i don't find it in git due to x86/64 unification.

maybe someone has a clue.... ?

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

