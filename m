Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZEAJOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZEAJOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbZEAJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:14:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZEAJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:14:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: [PATCH 17/27] add generic lib/checksum.c
Date: Fri, 1 May 2009 11:14:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de> <20090430223547.GO12974@lug-owl.de>
In-Reply-To: <20090430223547.GO12974@lug-owl.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011114.18880.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19SDKpX6kvisTq2TtYqD4Zq4DYq+zPofwPVK60
 51f7lQk8i8QOyeCW4HIeTUvw+H1F9IjaTQ4U0oDAUv8QVUrF7D
 QxUx+AutfXR3xPMOhABaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Jan-Benedict Glaw wrote:
> I haven't looked at the code in detail, but it would be nice to see it
> show up soon. Just faced the IP checksumming code while resurrecting
> the VAX port.

I hope my other header changes are helping you as well, that
was the main point. The checksum code was one of the hardest
to consolidate because every architecture tries to optimize
this in a different way. After merging all the different
approaches and throwing away all the assembly code from
each of them, I made the code practically identical to
Michals version.

Please tell me if you need more hooks in the checksum
code for VAX optimizations. You might want to try overriding
the csum_fold function.

	Arnd <><
