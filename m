Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZGRSxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZGRSxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 14:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZGRSxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 14:53:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37554 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbZGRSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 14:53:15 -0400
X-Sasl-enc: 8Alr3WM8XHELyRerLEyx3aadQo9zOUSPlUIfwU9kr862 1247943194
Date: Sat, 18 Jul 2009 15:53:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvram: Fix root triggerable integer overflow crash
Message-ID: <20090718185311.GA13198@khazad-dum.debian.net>
References: <200907180256.45934.mb@bu3sch.de>
 <20090718150909.GA1191@khazad-dum.debian.net>
 <200907181944.33338.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907181944.33338.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009, Michael Buesch wrote:
> On Saturday 18 July 2009 17:09:09 Henrique de Moraes Holschuh wrote:
> > On Sat, 18 Jul 2009, Michael Buesch wrote:
> > > This bug probably is exploitable by overwriting the function return address or something
> > > like that. But let's hope there's no distribution out there with user write permissions
> > > on the /dev/nvram node. So it's probably only exploitable by root.
> > 
> > I have seen setups with group-writeable /dev/nvram to support some (old!)
> > thinkpad utilities.
> 
> Yes it is  crw-rw---- 1 root root  on Debian.

That is not a problem. "crw-rw---- 1 root nvram", would be.  That becomes a
local privilege escalation right there, if it can be exploited for something
other than DoS (which looks somewhat likely).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
