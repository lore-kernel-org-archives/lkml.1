Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbZCaTrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbZCaTrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbZCaTrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:47:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:23930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759625AbZCaTrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:47:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,303,1235980800"; 
   d="scan'208";a="399149150"
Message-ID: <49D27334.5080809@linux.intel.com>
Date: Tue, 31 Mar 2009 12:47:00 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Hans-Peter Jansen <hpj@urpla.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain> <200903310000.11522.hpj@urpla.net> <49D142AC.8090701@linux.intel.com> <49D27116.8090102@garzik.org>
In-Reply-To: <49D27116.8090102@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Arjan van de Ven wrote:
>> Hans-Peter Jansen wrote:
>>> Am Freitag, 27. März 2009 schrieb Linus Torvalds:
>>>
>>> I always wonder, why Arjan does not intervene for his kerneloops.org 
>>> project, since your approach opens a window of uncertainty during the 
>>> merge window when simply using git as an efficient fetch tool.
>>
>> I would *love* it if Linus would, as first commit mark his tree as 
>> "-git0"
>> (as per snapshots) or "-rc0". So that I can split the "final" versus
>> "merge window" oopses.
> 
> Can't you discern that from the v$VERSION tag?  According to your 
> definition, -git0 would simply be v2.6.29 commit + 1, correct?

it needs to be something that is shown in the oops output...
... basically version or extraversion in the Makefile.
