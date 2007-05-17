Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXEQDLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXEQDLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXEQDLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:11:38 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:47362 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754751AbXEQDLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:11:37 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 15:11:35 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406B3428@gazelle.ad.endace.com>
In-Reply-To: <17995.49602.427417.500049@notabene.brown>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceYLYcNVbT46ifCRUmdglgeGfs1oQAAUIiw
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com><17994.19043.771733.453896@notabene.brown><659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com><17995.42562.870806.396617@notabene.brown><659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com> <17995.49602.427417.500049@notabene.brown>
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: "Neil Brown" <neilb@suse.de>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried the patch, same problem show up, but no bug_on report

Is there any other things I can do?


Jeff


> Yes, I meant 2T, and yes, the components are always over 2T.  
> So I'm at a complete loss.  The raid0 code follows the same 
> paths and does the same things and uses 64bit arithmetic where needed.
> 
> So I have no idea how there could be a difference between 
> these two cases.  
> 
> I'm at a loss...
> 
> NeilBrown
> 
