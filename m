Return-Path: <linux-kernel-owner+w=401wt.eu-S934058AbZJMSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058AbZJMSmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbZJMSmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:42:19 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:45350 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760087AbZJMSmR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:42:17 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Mukker, Atul" <Atul.Mukker@lsi.com>
Date: Tue, 13 Oct 2009 12:41:25 -0600
Subject: RE: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support
 during the FW boot-up and fixed the 64 bit sense buff error.
Thread-Topic: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support
 during the FW boot-up and fixed the 64 bit sense buff error.
Thread-Index: AcpMK95EB7pWA7cdTVaV/A3GKd91hAAAaHeQ
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B772447A@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512407@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
 <1255455442.2855.230.camel@localhost.localdomain>
In-Reply-To: <1255455442.2855.230.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

Thanks for the review.  Agree with you. I saw you already split this patch in two.  Thanks so much for doing that. 

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Tuesday, October 13, 2009 1:37 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Austria, Winston; Mukker, Atul
Subject: Re: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support during the FW boot-up and fixed the 64 bit sense buff error.

On Tue, 2009-10-06 at 14:52 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Add the 3 mins support during the FW boot-up to the driver.  Also add the fix for the 64 bit sense buff error.

OK, so this one has to be split ... that's a timing enhancement mixed
with a bug fix which seems to be very real and need backporting

James


