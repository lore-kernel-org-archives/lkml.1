Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXK2QNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXK2QNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbXK2QNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:13:01 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:51579 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159AbXK2QNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:13:00 -0500
In-Reply-To: <20071128195042.047049fc@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Out of tree module using LSM
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OFEBCE2F50.DE7D5873-ON802573A2.00555E0F-802573A2.00590DA4@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Thu, 29 Nov 2007 16:12:56 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 29/11/2007 16:12:58,
	Serialize complete at 29/11/2007 16:12:58
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 28/11/2007 19:50:42:

> > So as there is no question the current code does some ugly things it 
is 
> > even more true that we would be even more happy to use an official 
API. 
> > LSM was that and we were happily using it which we won't be able to do 
if 
> > it abruptly goes away. Yes it is not a perfect match but until it is 
> > modified to be better, or until something appropriate is designed and 
> > implemented, it would be very nice if it could stay.
> 
> So for an SELinux based system what you are saying is you want to be 
able
> to stack your module with the SELinux module and after SELinux has
> considered policy rules still be able to veto them on the grounds that
> you are say about to serve a virus to a windows box ?

Basically yes but the effective scenario is a bit wider. Local actions 
like disallowing execution of rootkits, exploits and other similar malware 
are also interesting. Another example would be enforcing a corporate 
policy on which IM clients shouldn't be used so it is not just fileserver 
scenario in which Linux machines can be compromised.

But really I am not the best person to know all current attack vectors. 
Overall set of requirements and ideas is something we are working on with 
other vendors and hopefully with the community. This is one of the two 
main things my original post was about.

--
Tvrtko August Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."

Tel: 01235 559933
Web: www.sophos.com
Protecting business against viruses, spyware, spam and policy abuse


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

