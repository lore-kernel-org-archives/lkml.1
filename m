Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbXHHIzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbXHHIzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXHHIyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:54:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:3185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXHHIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hAES7PMCU2fRTApRONxEOw/Wi2HQ0IqMIdxgWT+8cJ/BGGUoizPPhTArwlIVS4BpZThwYlew4KaiqtOLzVgB7MazlwfHcyqUufY4XwtJez+rgR4REHqC3zxXF8D/a2rEU3QNTuGfJC5QqJLkdXauHxzO69gYArGv+0fS0Rb/WMA=
Message-ID: <46B984D4.9020600@gmail.com>
Date: Wed, 08 Aug 2007 17:54:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com> <20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 08 Aug 2007 01:57:07 -0600,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
>>> Got it: It's patch 6, the readdir simplification.
>>>
>>> (The udev on that guest is ancient (063)...)
>> Ok.  That is weird.
> 
> More weirdness. If I activate another dasd from the repair file
> system, /dev/dasdb is created...
> 
> Same if I set the card reader online: /dev/vmrdr-0.0.000c is created as
> expected.
> 
>> Does it depend on the order in which the dentries are returned from
>> readdir?
> 
> I'd think not.
> 
>> Unless I made a really stupid error otherwise the two versions
>> of readdir should have the same semantics.
> 
> Yes, your patch looks sane. I have no idea why it breaks stuff...

Are you sure it's patch 6?  Patch 17 adds a deadlock in rename path.

-- 
tejun
