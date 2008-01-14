Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYANGXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYANGXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYANGXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:23:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:6552 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYANGXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:23:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Sun, 13 Jan 2008 22:23:15 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Date: Mon, 14 Jan 2008 14:23:04 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC2@hkemmail01.nvidia.com>
In-Reply-To: <478AF10D.5080805@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
Thread-Index: AchWbS2QVdWn4volTsSbbPERfc6unwACHsLw
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca> <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com> <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com> <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca> <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com> <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com> <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca> <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com> <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com> <478567D8.10601@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com> <478812C9.1000901@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com> <478AF10D.5080805@shaw.ca>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "Tejun Heo" <htejun@gmail.com>, "Mark Lord" <liml@rtr.ca>,
       "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Allen Martin" <AMartin@nvidia.com>, "Peer Chen" <pchen@nvidia.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "David Milburn" <dmilburn@redhat.com>
X-OriginalArrivalTime: 14 Jan 2008 06:23:05.0718 (UTC) FILETIME=[EC63B960:01C85675]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> As I mentioned, this doesn't seem to resolve the problem we're seeing 
> with rapidly intermixed NCQ commands and cache flushes (at 
> least, if I 
> take out the arbitrary 20usec delay from the driver and add 
> this patch, 
> the problem still shows up). It could be a similar problem, 
> though, of 
> commands being issued before the controller is really ready 
> for them. If 
> you or others at NVIDIA could assist in tracking down that problem it 
> would be appreciated..
>
Ok , i will track down that problem. 
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
