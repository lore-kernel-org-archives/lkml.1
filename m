Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbXI0AR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbXI0AR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 20:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbXI0ARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 20:17:51 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:53336 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbXI0ARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 20:17:50 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 20:17:50 EDT
From: Konrad Rzeszutek <konrad@darnok.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add iSCSI iBFT support.
Date: Wed, 26 Sep 2007 20:16:45 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926141335.8faa5cb9.randy.dunlap@oracle.com>
In-Reply-To: <20070926141335.8faa5cb9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709262016.47488.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> i.e., what is this binary blob  (?)
>
> I don't see a binary blob in this patch (as stated in the first
> sentence).  I'd say that this patch adds methods for exporting
> (or exposing) the ibft thru sysfs.

I used the wrong choice of words. The correct one is, as you say, to
add methods for exporting the iBFT through sysfs.

>
> Is there some good reason that the iSCSI connection information
> shouldn't be exposed in real sysfs attribute files instead of just
> in a binary file?

My end goal is to export the iBFT data via individual sysfs attribute files. I 
was thinking to do that in the next version of this code and build on top of 
this patch. 

This way the existing exploiter (iscsi-initiator-utils) can use the parsing 
code it already has to extract the data from the binary blob. Then in the 
next version of the iscsi-initiator-utils (and for the kernel) I can post a 
patch for supporting (and exporting in the kernel) individual sysfs attribute 
files.
