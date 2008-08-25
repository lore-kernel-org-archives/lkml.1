Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYHYH4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYHYH4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHYH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:56:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYHYH4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:56:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Date: Mon, 25 Aug 2008 09:55:57 +0200
User-Agent: KMail/1.9.9
Cc: cbe-oss-dev@ozlabs.org, Robert Richter <robert.richter@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808211014.42683.arnd@arndb.de> <18610.20951.764057.574721@cargo.ozlabs.ibm.com>
In-Reply-To: <18610.20951.764057.574721@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808250955.57638.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Yq1UENDwnzcCWV+29JCPGCWmowfbvzJxZsot
 SsfXnm5y2q/TT1uoP3tsuRJaHVL7v3YJNa8TlkRey6W6hOry0Y
 gNB5wXWoCpWpC0J4CN4Jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2008, Paul Mackerras wrote:
> 
> > Since rc4 is out now, I understand if you feel more comfortable with
> > putting the patch into -next instead of -merge.
> 
> Linus has been getting stricter about only putting in fixes for
> regressions and serious bugs (see his recent email to Dave Airlie on
> LKML for instance).  I assume that the corruption is just in the data
> that is supplied to userspace and doesn't extend to any kernel data
> structures.

That's right, please queue it for -next then.

> > Note that the second patch is trivial and fixes an oopsable condition
> > of the kernel, so at least that should still go into 2.6.27.
> 
> OK, I'll cherry-pick that one for my next batch for Linus.

Thanks,

	Arnd <><
