Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZBZAZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZBZAZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZBZAZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:25:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZBZAY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:24:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/7] Use strict kernel types to fix the world
Date: Thu, 26 Feb 2009 01:24:12 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20090225235138.062045835@arndb.de> <49A5DC30.4080803@zytor.com>
In-Reply-To: <49A5DC30.4080803@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902260124.13641.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+peQ9LA8w2QHav9kqao2eConqXkh5iN4sOMd7
 lbISihbdxd1JJ2ERDs0cnqUwbAdy27iZwIqh8Daip4MPXixayB
 tUzNsmbydYQQ2I9UtwZ8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, H. Peter Anvin wrote:
> 
> > I split out netfilter, DRM and MTD, because of both
> > size and potentially controversial changes.
> 
> I take it this supercedes your previous monolithic patch?

Patch 1/7 supercedes my previous patch and is still as monolithic,
except for the separate 6/7 hunk. I only split the integer type
patches by subsystem, but I did these from scratch now.

Patch 7/7 is a new one, based on your input from the last time
we discussed it.

	Arnd <><
