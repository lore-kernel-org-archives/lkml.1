Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbYGOTOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbYGOTOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYGOTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:14:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46256 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbYGOTOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:14:34 -0400
Message-ID: <487CF70C.1030309@garzik.org>
Date: Tue, 15 Jul 2008 15:14:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from	in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu>
In-Reply-To: <20080715185801.GH8185@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Jul 15, 2008 at 02:44:46PM -0400, Jeff Garzik wrote:
>> All of the regressions examples I am citing are cured by  
>> firmware-in-module, because they are all examples of problems that occur  
>> when you remove the ability to reproduce the same functional pieces as  
>> 2.6.26.
> 
> Jeff,
> 
> 	I think you've said this before, but let me try to help you
> cut to the chase.  You are willing to *implement*
> firmware-in-the-module for request_firmware(), but you want a
> commitment that David Woodhouse and Linus will accept such a patch
> before you go off and write it.  Is that right?
> 
> 	If so, may I suggest you start implementing, instead of
> sending e-mails?  For all the time people have spent arguing about it,
> maybe it could have been implemented already.

Already started, in fact, since Linus said he would not reject it out of 
hands.

Obviously that is not acceptance; I know as well as any that acceptance 
does not occur until the moment of upstream merge.


> 	Once it has been implemented, do you have any further
> objections aka ideas about how request_firmware() could be improved?

Further objections?  None major.

The two other minor problems I feel need solving, but are not related to 
breakage or regressions, are:

1) firmware should be able to live alongside the driver.  We don't need 
to start growing firmware/net alongside drivers/net, firmware/scsi 
alongside drivers/scsi, firmware/char alongside drivers/char, etc.

2) firmware should be able to be shipped in final format (binary), 
rather than ihex.


I feel strongly that 2.6.27 should not be released without 
firmware-in-module, for all the reasons mentioned in these threads. 
It's a major regression, IMO, without firmware-in-module ability.

The other stuff (#1, #2 in list above) is small potatoes.

	Jeff



