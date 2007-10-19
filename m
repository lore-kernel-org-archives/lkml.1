Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXJSPX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXJSPX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJSPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:23:52 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:28142 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbXJSPXv (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:23:51 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
Date: Fri, 19 Oct 2007 17:23:48 +0200
User-Agent: KMail/1.9.7
Cc: Jan Engelhardt <jengelh@computergmbh.de>, carsteno@de.ibm.com,
       Mike Lampard <mike@secnet.net.au>, Linux-kernel@vger.kernel.org,
       Aurelien Jarno <aurelien@aurel32.net>, kvm-devel@lists.sourceforge.net
References: <47189371.7080104@de.ibm.com> <200710191648.32157.borntraeger@de.ibm.com> <4718C5E0.9000204@bull.net>
In-Reply-To: <4718C5E0.9000204@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191723.48104.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 19. Oktober 2007 schrieb Laurent Vivier:
> Did you patch kvm.git with patch-2.6.23.1.bz2 or did you download 
> linux-2.6.23.1.tar.bz2 ?
> 
> 2.6.23.1 corrects nothing except sata_mv...

Yes I know. The question we tried to answer was: is the bug in 2.6.23 or was
it introduced after 2.6.23, as kvm.git  already contains lots of post 2. 6.23 
stuff.
Current state is:

kvm.git with tag 2.6.23-rc6 works for days without a problem.
2.6.23.1 vanilla has survived and is currently still under test.
kvm.git tag master killed our filesystem at least three times.since monday.

I will continue to bang on 2.6.23.1 to see if its really fine. After that,
maybe I will try to bisect on kvm.git, but this will take quite a long time,
given that we had to reinstall the system due to this error. 

Christian
