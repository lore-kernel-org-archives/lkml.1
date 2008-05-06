Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbYEFJGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbYEFJGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764407AbYEFJDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:03:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763737AbYEFJDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:03:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 45/56] microblaze_v2: headers simple files - empty or redirect to asm-generic
Date: Tue, 6 May 2008 11:02:20 +0200
User-Agent: KMail/1.9.9
Cc: "John Williams" <john.williams@petalogix.com>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, "Michal Simek" <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <1209954849.5798.80.camel@localhost> <fa686aa40805050810w2a0ff71fv9daff4ba198cf978@mail.gmail.com>
In-Reply-To: <fa686aa40805050810w2a0ff71fv9daff4ba198cf978@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805061102.22528.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tKo/QjA/PJyOctXH2bx+skJ0LTpNE4CJ+iEi
 YDKJf9ocpbpjQqwHXd+CTWsydg7Spu/yppmwp+hSIQsOmHTZh7
 A590A/xaCQqeuX0g4Mjjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, Grant Likely wrote:
> >  These are all just includes of asm-generic/* (hooray!).
> >
> >  But, is it reasonable to to suggest adding asm-generic at the end of the
> >  kernel include path, and save all this verbosity?
> >
> >  Principle of least surprise maybe?
> 
> Convention in the other archs is already established to explicitly
> include asm-generic files one by one.  It is probably best to match
> existing convention for commonality sake.

Right, I agree. We may eventually want to move to something more sophisticated,
but we should not change the current way of doing this while we're in the process
of adding a new architecture.

	Arnd <><
