Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbZDQO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbZDQO1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbZDQO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:27:33 -0400
Received: from emulex.emulex.com ([138.239.112.1]:57236 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337AbZDQO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:27:32 -0400
Message-ID: <49E891C8.1050007@emulex.com>
Date: Fri, 17 Apr 2009 10:27:20 -0400
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Daniel Debonzi <debonzi@linux.vnet.ibm.com>,
       "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> <49E88E3F.8030107@vlnb.net>
In-Reply-To: <49E88E3F.8030107@vlnb.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2009 14:27:23.0798 (UTC) FILETIME=[9FF61B60:01C9BF68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Let's go with root in /sys/class/scsi_tgt. In future, if somebody 
> objects, we can easily change it.
>   

This maps too closely to the scsi midlayer names, especially the real 
target devices initiators see - which are not yet in sysfs but there has 
been discussion of in the past. I would prefer that you used 
/sys/class/scst_tgt.  And yes, as part of the class level support in the 
midlayer/kernel, they are generally symlinks to the actual kobject in 
the /sys/devices that the class entity corresponds to.

IMHO - "scsi_tgt" also seems a bit presumptuous to propose if SCST is 
not, in it's entirety, going to be the adapter target interface pulled 
in upstream.  Thus, another reason I prefer the "scst_tgt" name, as it 
makes it very specific to SCST itself, and lessens any co-existence 
conflicts if there are any in the future.

-- james s
