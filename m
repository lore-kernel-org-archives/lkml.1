Return-Path: <linux-kernel-owner+w=401wt.eu-S1763890AbXJSLXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763890AbXJSLXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXJSLXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:23:05 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47631 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbXJSLXE (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:23:04 -0400
Message-ID: <47189371.7080104@de.ibm.com>
Date: Fri, 19 Oct 2007 13:22:25 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: severe bug in 2.6.23+ kvm.git
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

we've experienced a severe bug in current kvm.git, that may have been 
introduced to the git tree quite recently around last weekend. 2.6.23 
is broken, 2.6.23-rc8 works for us. The symptom is, that our operon 
kvm test machine shredders its hard disk content to a state that is 
not correctably by the file system checker. We use raid1 md mirrored 
ext3 file systems on 4 sata hard disks on it, and we've verified 
correct operation of the hardware via badblocks and memtest86.
The problem occurs even without kvm modules loaded, so the cause seems 
to be something that Avi pulled elsewhere. Did anyone else experience 
similar problems with the 2.6.23 based kvm tree? Does anyone have an 
idea about a possible cause, which would help us debugging it?

thanks,
Carsten
