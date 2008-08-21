Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYHUTRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYHUTRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYHUTQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:16:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:19369 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYHUTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lpKUJlvarsdamnASfXmdWOUSfK9nX3x3f4Um3qklmpdRkjb2Xqb1FIncYeZv9b3mh3
         UMBdc+hEFc8I4n9GBvjvS5UBXplr8CG+Nb0g0pRqjcoasKmhBsQR5nXdmEBQGBNwNbmu
         3Pex6VHnZz9/diR/Vu3C+JOz41RFiKO8FoKTU=
Message-ID: <19f34abd0808211216q319e4fbclc41b362d8dbdcbc0@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:16:50 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200808212113.53411.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
	 <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com>
	 <19f34abd0808211145y1c3d5aedwf8e918afeba9cc98@mail.gmail.com>
	 <200808212113.53411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> ...followed by the "unable to handle kernel paging request" as in
>> previous e-mail. The numbers 00100104 and 00200200 seem to appear all
>> the time.
>>
>> At least it is 100% reproducible now and with nice oopses too :-)
>
> Hm, slab corruption, it seems.
>
> Do you use SLAB or SLUB?

SLUB, with all possible debugging:

CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y

(Thanks for helping out.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
