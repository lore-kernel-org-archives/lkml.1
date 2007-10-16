Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbXJPIxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbXJPIxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbXJPIxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:53:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43250 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbXJPIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:53:15 -0400
Date: Tue, 16 Oct 2007 10:53:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [patch][rfc] rewrite ramdisk
In-Reply-To: <200710161826.55834.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710161052380.10197@fbirervta.pbzchgretzou.qr>
References: <200710151028.34407.borntraeger@de.ibm.com>
 <200710161807.41157.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710161015310.10197@fbirervta.pbzchgretzou.qr>
 <200710161826.55834.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 16 2007 18:26, Nick Piggin wrote:
>> >> It also does not seem needed, since it did not exist before.
>> >> It should go, you can set the variable with brd.rd_nr=XXX (same
>> >> goes for ramdisk_size).
>> >
>> >But only if it's a module?
>>
>> Attributes always work. Try vt.default_red=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
>> and you will see.
>
>Ah, nice. (I don't use them much!). Still, backward compat I
>think is needed if we are to replace rd.c.
>
Like I said, I did not see rd_nr in Documentation/kernel-parameters.txt
so I thought there was no compat.
