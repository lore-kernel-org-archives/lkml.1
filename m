Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbXJWFpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbXJWFpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXJWFpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:45:01 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:50782 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXJWFpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:45:00 -0400
Message-ID: <471D8A4C.3020101@debian.org>
Date: Tue, 23 Oct 2007 07:44:44 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> I do have a pseudo LSM called "multiadm" at 
> http://freshmeat.net/p/multiadm/ , quoting:

> Policy is dead simple since it is based on UIDs. The UID ranges can be 
> set on module load time or during runtime (sysfs params). This LSM is 
> basically grants extra rights unlike most other LSMs[1], which is why 
> modprobe makes much more sense here. (It also does not have to do any 
> security labelling that would require it to be loaded at boot time 
> already.)

But his is against LSM design (and first agreements about LSM):
LSM can deny rights, but it should not give extra permissions
or bypass standard unix permissions.

ciao
	cate
