Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXJSO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXJSO6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760627AbXJSO6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:58:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46287 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760454AbXJSO6N convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:58:13 -0400
Message-ID: <4718C5E0.9000204@bull.net>
Date: Fri, 19 Oct 2007 16:57:36 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, carsteno@de.ibm.com,
       Mike Lampard <mike@secnet.net.au>, Linux-kernel@vger.kernel.org,
       Aurelien Jarno <aurelien@aurel32.net>, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <4718B4DB.1000202@de.ibm.com>	<Pine.LNX.4.64.0710191618450.1997@fbirervta.pbzchgretzou.qr> <200710191648.32157.borntraeger@de.ibm.com>
In-Reply-To: <200710191648.32157.borntraeger@de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 17:04:43,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 17:04:44,
	Serialize complete at 19/10/2007 17:04:44
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger a écrit :
> Am Freitag, 19. Oktober 2007 schrieb Jan Engelhardt:
>> On Oct 19 2007 15:44, Carsten Otte wrote:
>>> Carsten Otte wrote:
>>>> First thing we do, is figure whether or not 2.6.23.1 as released breaks our
>>>> system too. This way, we can either focus on differences between Linus and
>>>> Avi, or turn on the big red warning sign saying "regression".
>>> Looks like 2.6.23.1 works fine on that box. We'll leave it running over
>>> the weekend with "while true; do make; make clean; done".
>> Well, do you happen to use sata_mv?
> 
> no, we have nvidia, so its sata_nv.

Did you patch kvm.git with patch-2.6.23.1.bz2 or did you download 
linux-2.6.23.1.tar.bz2 ?

2.6.23.1 corrects nothing except sata_mv...

Laurent
-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

