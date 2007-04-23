Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbXDWWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbXDWWLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXDWWLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:11:20 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:36340 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbXDWWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:11:19 -0400
Message-ID: <462D2EFD.4030507@emc.com>
Date: Mon, 23 Apr 2007 18:11:09 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Avishay Traeger <atraeger@cs.sunysb.edu>
CC: Karuna sagar K <karunasagark@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Testing framework
References: <2e4afe1e0704221346u6d6baec1uab88dc273ff08de9@mail.gmail.com> <1177337041.3704.4.camel@localhost>
In-Reply-To: <1177337041.3704.4.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.23.144434
X-PerlMx-Spam: Gauge=, SPAM=1%, Reasons='EMC_FROM_0+ -3, LEO_OBFU_SUBJ_RE 0.1, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avishay Traeger wrote:
> On Mon, 2007-04-23 at 02:16 +0530, Karuna sagar K wrote:
>> For some time I had been working on this file system test framework.
>> Now I have a implementation for the same and below is the explanation.
>> Any comments are welcome.
> 
> <snip>
> 
> You may want to check out the paper "EXPLODE: A Lightweight, General
> System for Finding Serious Storage System Errors" from OSDI 2006 (if you
> haven't already).  The idea sounds very similar to me, although I
> haven't read all the details of your proposal.
> 
> Avishay
> 

It would also be interesting to use the disk error injection patches 
that Mark Lord sent out recently to introduce real sector level 
corruption.  When your file systems are large enough and old enough, 
getting bad sectors and IO errors during an fsck stresses things in 
interesting ways ;-)

ric
