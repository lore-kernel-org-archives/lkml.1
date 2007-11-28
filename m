Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXK1Mp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXK1Mp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXK1MpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:45:08 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:44394 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXK1MpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:45:06 -0500
From: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
To: linux-kernel@vger.kernel.org
Subject: Out of tree module using LSM
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Date: Wed, 28 Nov 2007 12:42:52 +0000
Message-Id: <200711281242.52941.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.2FP1|January
 10, 2007) at 28/11/2007 12:45:04,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 28/11/2007 12:45:05,
	Serialize complete at 28/11/2007 12:45:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, all,

During one recent LKML discussion 
(http://marc.info/?l=linux-kernel&m=119267398722085&w=2) about LSM going 
static  you called for LSM users to speak up.

We here at Sophos (the fourth largest endpoint security vendor in the world) 
have such a module called Talpa which is a part of our main endpoint security 
product for Linux  that protects from viruses and malware hosted on Linux, 
including those targetting Windows or other connected devices,  
(http://www.sophos.com/products/enterprise/endpoint/security-and-control/linux/index.html) 
which is GPL code and has been in the field for almost three years now. It's 
source code has been shipping with the product from the start.  We also have 
a SourceForge project at http://sourceforge.net/projects/talpa/ to host it.

In essence, what our module does is it intercepts file accesses and allows 
userspace daemons to vet them. One of the means we implemented that is 
through LSM and although it is not a perfect match for such use we prefer to 
use an official interface. Unfortunately, with time it became impossible to 
use LSM on some distributions (SELinux) so we had to implement other 
intercept methods which are significantly less nice, and which may also 
become unworkable over time.

The main point here is that making LSM not available for modules makes our 
life even more difficult and we would like to ask you to revert that change 
until another acceptable, secure solution is found.

At this point I would not like this to turn into a discussion on technical or 
code merits of our current approach. It is just that usage scenarios of 
(dis-)allowing access to files based on their content, regardless of the 
actual details, do sound like a reasonable idea. What we would like to do is 
to start discussion about possible solutions in which other interested 
parties will hopefully join and in future create some progress on this front.

-- 
Tvrtko August Ursulin
Senior Software Engineer, Sophos

Tel: 01235 559933
Web: www.sophos.com
Protecting business against viruses, spyware, spam and policy abuse

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

