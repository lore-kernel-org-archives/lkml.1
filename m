Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYFCK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYFCK5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYFCK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:57:32 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:54273 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYFCK5b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:57:31 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 06:57:31 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:From:Organization:To:Subject:Date:User-Agent:
   MIME-Version:Content-Type:Content-Transfer-Encoding:
   Content-Disposition:Message-Id;
  b=v8AP3kUbeXT8DXJ588XLdgPoMxJF7TCYy25ppJkbKmQykKHr23HZW/D9
   GR2HLv4cB09EhYszndKdLoStlBoNzijz9NV3ZiY9X1XrFsvxVVR5SJKfl
   oc8foRkJsmFLjkG;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.27,581,1204498800"; 
   d="scan'208";a="14458423"
X-IronPort-AV: E=Sophos;i="4.27,582,1204498800"; 
   d="scan'208";a="34432211"
From: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Organization: IP BC E SW OS
To: linux-kernel@vger.kernel.org
Subject: Who can backport the AHCI driver to older kernels
Date: Tue, 3 Jun 2008 12:47:41 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
I need help and/or advice on the following problem:

New mainboard platfrom with latest chipset from a chipset vendor that 
can't do the job that we are asking for. The chipset (especially the
SATA controller is supported in Kernel 2.6.24 and later. 

The target market for those boards is using old fashioned distributions 
like CentOS, Debian, Fedora 8 openSUSE 10 and so on. So the gap is that 
the latest driver from 2.6.24 is not yet in those distributions. The 
impact of this is that the customer in the target market can't use the
mainboards to run actual Linux distributions on them.

So there is a need ot backport e.g. the AHCI driver from 2.6.24 to 
2.6.16 or 2.6.18. Doing a diff on the sources makes me think this is a 
sort of "mission impossible" since it sureley isn't just the ahci code
that changed but also a lot in the kernel infrastructure meanwhile.

So what options do we have to help the customer? Changing to 2.6.24 
kernel is not an option due to the customer. So it looks like the 
only way to "solve" this is a backport, but then we come to "who can
do this?". 

Any hints welcome and thanks a lot for your attention
Rainer
-- 
Dipl.-Inf. (FH) Rainer Koenig
Project Manager Linux Business Clients
Dept. IP BC E SW OS

Fujitsu Siemens Computers 
Bürgermeister-Ullrich-Str. 100
86199 Augsburg
Germany

Telephone: +49-821-804-3321
Telefax:   +49-821-804-2131
Mail:      mailto:Rainer.Koenig@fujitsu-siemens.com 

Internet         www.fujitsu-siemens.com
Company Details  www.fujitsu-siemens.com/imprint.html
