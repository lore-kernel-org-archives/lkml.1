Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbXJSMV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbXJSMV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXJSMVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:21:47 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51206 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbXJSMVr (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:21:47 -0400
Message-ID: <4718A14B.4060008@de.ibm.com>
Date: Fri, 19 Oct 2007 14:21:31 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Mike Lampard <mike@secnet.net.au>
CC: kvm-devel@lists.sourceforge.net, carsteno@de.ibm.com,
       Aurelien Jarno <aurelien@aurel32.net>, Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net> <47189706.1040809@de.ibm.com> <200710192127.17584.mike@secnet.net.au>
In-Reply-To: <200710192127.17584.mike@secnet.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Lampard wrote:
> There was a commit ab9c232286c2b77be78441c2d8396500b045777e regarding libata 
> on linus's master tree that happened on Friday, that was pulled into kvm git 
> over the weekend.. I dont know if that may be affecting you.. there is/was 
> also chatter on LKML regarding some problems with s/g, you may want to check 
> there.
Oh, that's a couple of patches in question. Git-bisect seems to be a 
loong way once you loose your installation every time you try.
First thing we do, is figure whether or not 2.6.23.1 as released 
breaks our system too. This way, we can either focus on differences 
between Linus and Avi, or turn on the big red warning sign saying 
"regression".
