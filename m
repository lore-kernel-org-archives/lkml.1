Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZBUVfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZBUVfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 16:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZBUVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 16:35:22 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:38922 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbZBUVfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 16:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ix/fJjEalABMo/WmkBG73Qrz3D2WOscsBcsg+gfY+EebQ6dNPg/njTACDSnTd/HpUB
         PMvx1fegNg5aNfMQr55psGdFgxfhf7b7iW8FLdV620N9Jc6EZ1KF20FubsqmhVnDDatB
         oAWKg+2OgMaGAwI2x4A5m4uoTnoebvf3boVsA=
MIME-Version: 1.0
In-Reply-To: <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com>
References: <20090221211908.GA6798@silver.sucs.org>
	 <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com>
Date: Sat, 21 Feb 2009 22:35:19 +0100
Message-ID: <19f34abd0902211335g354b6860ic7244fb699d7d01b@mail.gmail.com>
Subject: Re: Is kmemcheck currently broken on tip?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2009/2/21 Sitsofe Wheeler <sitsofe@yahoo.com>:
>> Hi,
>>
>> I've been trying to test kmemcheck in linux-tip on my EeePC and things
>> have been going suspiciously not so slow with little extra memory used
>> (at least compared to the last time I used kmemcheck). While I see
>> [    0.063412] kmemcheck: "Bugs, beware!"
>> in dmesg, I'm not sure kmemcheck is working especially since nothing is
>> flagged when I trigger the issue described in
>> http://marc.info/?l=linux-kernel&m=123472656015761&w=1 ...

Ah, sorry, you'll probably have to disable SLUB debugging on the
command line if it was enabled by default in the config. Boot with
slub_debug=- parameter. Maybe we should print a warning for this...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
