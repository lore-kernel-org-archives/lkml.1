Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbYA2E7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbYA2E7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYA2E7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:59:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:3628 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYA2E7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:59:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 28 Jan 2008 20:59:05 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Date: Tue, 29 Jan 2008 12:59:00 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AD4@hkemmail01.nvidia.com>
In-Reply-To: <479E6A60.5070208@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Thread-Index: AchiCWKu7Yk0EjHuSPOl4zlC+uMFqAAKOHIA
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca> <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com> <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com> <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca> <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com> <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com> <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca> <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com> <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com> <478567D8.10601@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com> <478812C9.1000901@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com> <4797DF30.6050208@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2ACA@hkemmail01.nvidia.com> <479E6A60.5070208@shaw.ca>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "Allen Martin" <AMartin@nvidia.com>, "Tejun Heo" <htejun@gmail.com>,
       "Mark Lord" <liml@rtr.ca>, "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Peer Chen" <pchen@nvidia.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "David Milburn" <dmilburn@redhat.com>
X-OriginalArrivalTime: 29 Jan 2008 04:59:01.0948 (UTC) FILETIME=[AA43BFC0:01C86233]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert wrote:
> Kuan Luo wrote:
> > Robert worte.
> >> Kuan, does this patch (using the notifiers to see if the 
> command is 
> >> really done) still work if one port on the controller has 
> >> ADMA disabled 
> >> because it's in ATAPI mode? I seem to recall Allen Martin 
> mentioning 
> >> that notifiers wouldn't work in this case.
> >>
> > 
> > I just tried the 2.6.24-rc7 sata_nv driver with one hd and  
> one cdrom in
> > the same controller. 
> > I mkfs hd and mounted the cdrom and no error happened.
> > 
> > Allen,  is there anything about notifier that we should pay 
> attention
> > to?
> 
> Assuming not, then this patch should be applied..
> 
> 

The patch should be applied.
We use the notifier register  and there is nothing to do with our
notifier register in atapi mode.

Allen wrote:
I think that's one of the cases where memory notifiers don't work (one
of the drives is not in ADMA mode either because it's ATAPI or it's in
legacy mode).  There's no issue with the notifier registers though. 
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
