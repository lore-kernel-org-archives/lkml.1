Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXJSLh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXJSLh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXJSLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:37:50 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50366 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXJSLht (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:37:49 -0400
Message-ID: <47189706.1040809@de.ibm.com>
Date: Fri, 19 Oct 2007 13:37:42 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Aurelien Jarno <aurelien@aurel32.net>
CC: carsteno@de.ibm.com,
       "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net>
In-Reply-To: <47189585.5010901@aurel32.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aurelien Jarno wrote:
> Could you please precise what is corrupted? The guest disk image?
As stated, we actually did not run any guests and did not load the kvm 
kernel modules.
The host root file system gets corrupted to an extend not correctable 
by the file system checker (we gave it 24h to repair, then interrupted 
it), and it's very easy to reproduce: a simple kernel make on the 
hosts lets us reinstall the entire host operating system.


