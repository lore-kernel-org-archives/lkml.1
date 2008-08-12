Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbYHLBnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbYHLBnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYHLBnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:43:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:60657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYHLBnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ky/pOmSB6+pTp1iAJiS+s81eQTLPCd49coNs5E4v5Cofxx3foGeUUBfwxITzwKqmIg
         9PVtpTfWGr7iNy788Aet9DD9pVHef/8AEpsw8CoP7fnOO44Qymjk4IRvH+9etQfKSOhS
         +QZd6NYJwVGEFS2rKVcjT+dM3sx0k0FoyXVdU=
Message-ID: <dd18b0c30808111843y3f2aa2fbrbc9fcbd16913311a@mail.gmail.com>
Date: Mon, 11 Aug 2008 18:43:05 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend issues on 2.6.27-rc2 (was: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374)
Cc: "Nico Schottelius" 
	<nico-linux-kernel-bugreport20080731@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
In-Reply-To: <200808112239.29292.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080731210507.GA6094@denkbrett.schottelius.org>
	 <200808071852.11080.rjw@sisk.pl>
	 <20080811180416.GA22969@denkbrett.schottelius.org>
	 <200808112239.29292.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 1:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 11 of August 2008, Nico Schottelius wrote:
>> Rafael J. Wysocki [Thu, Aug 07, 2008 at 06:52:10PM +0200]:
>> > > The problem continues to exist:
>> > >
>> > > I tested it on vanilla 2.6.27-rc2: Same problem, system does not wake up.
>> > >
>> > > Did not test the proposed patch, because it did not restore the console
>> > > in any tested case yet, though it at least wakes the system up.
>> >
>> > What graphics adapter is there in your box?
>>
>> x1400, using radeonhd (also from git)
>>
>> It's a T60 lenovo thinkpad.
>
> There also are models with Intel graphics, I think.
>
> Anyway, the problem is related to either the graphics driver, or ACPI.
>
> Please verify if any ACPI-related settings haven't changed in your .config
> between the good kernel and the failing one.
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Just to let you know, I am having suspend issues as well,
(not kernel related),
ATI chipset, my situation maybe different, but you never know.
last week I was using xorg 7.1 with no issues,
now after an upgrade through debian sid
xorg 7.3(or whatever the number is), the system wakes up
to a black screen, then after around two or three minuetes
I regain my screen again. Could be xorg, or something else.
Maybe you are having the same issue.

-- 
Justin P. Mattock
