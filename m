Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXGXQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXGXQvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXGXQvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:51:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55017 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXGXQvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:51:40 -0400
Date: Tue, 24 Jul 2007 18:51:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
In-Reply-To: <46A5E034.2030205@shadowen.org>
Message-ID: <Pine.LNX.4.64.0707241849340.18990@fbirervta.pbzchgretzou.qr>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com>
 <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org>
 <46A5E034.2030205@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 24 2007 12:19, Andy Whitcroft wrote:
>>>> if (err) {
>>>>     do_something();
>>>>     return -ERR;
>>>> } else {
>>>>     do_somthing_else();
>>>> }
>>>
>>> 	if (err) {
>>> 		do_something();
>>> 		return -ERR;
>>> 	} else
>>> 		do_something_else();
>> 
>> The kool kids on linux-usb-devel largely ended up deciding that the second
>> version looks dorky.
>
>Ok, now if either the preceeding block or following block has {}'s then
>we don't report this block for being one line long.  We will miss some
>this way, but hey.

As per Ingo Molnar [ http://lkml.org/lkml/2006/9/5/68 ],
all blocks in an if-else 'tree' should be {} if there is at least one
with more than two statements. (And I do not disagree.)


	Jan
-- 
