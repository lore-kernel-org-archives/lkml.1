Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXLKXPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXLKXPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXLKXPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:15:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:50269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXLKXPF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:15:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [RFC] Proposed new directory layout for kvm =?iso-8859-1?q?and=09virtualization?=
Date: Wed, 12 Dec 2007 00:14:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Avi Kivity <avi@qumranet.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <475E5CBB.9080608@qumranet.com> <20071211151143.GA7751@osiris.boeblingen.de.ibm.com> <475EB23E.1060002@qumranet.com>
In-Reply-To: <475EB23E.1060002@qumranet.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712120014.43314.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Qs2VL2LSxfWwZzbJ+miTeunZmXtWtb2H/VrP
 BS2zO6DQupinKxiE74h/viU8/Zk8tV5Q6C1fIRmBkzUY9t+SuL
 766B+7eOYeKzx7Xga3TQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007, Avi Kivity wrote:
> Heiko Carstens wrote:
> > On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
> >
> >>  arch/*/kvm/   arch dependent kvm code
> >>     
> >
> > Maybe arch/*/virt/ ? No need to add an own directory for each hypervisor.
> >
> There will be several kvm files in that directory for x86. If you have 
> just one file, I guess arch/*/virt/kvm.c is okay.

In that case, even arch/*/{mm,kernel}/kvm.c would work fine, as long as you
only want to support one hypervisor, or a small set of small files, there
is no need to have even have a virt directory.

However, if you want to have symmetry across the architectures, I think
arch/*/kvm/ works out best, along the lines of 
arch/*/{perfmon,crypto,xen,power}. Neither of these is particularly large,
but arch/* is typically not that crowded either.

	Arnd <><
