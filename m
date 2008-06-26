Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbYFZPMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbYFZPMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbYFZPMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:12:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:56363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYFZPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:12:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: Microblaze init port v4
Date: Thu, 26 Jun 2008 17:09:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
In-Reply-To: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261709.37045.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UtpV3kVqFeodrQ2pnHbn2BM/IvQH5TfLonZp
 D8oBiOD5k/vHOcW/jnExgNdGYo3pERpkwrmr5avPmlAaYbv1y1
 BFWvKh0MXKPw0jvjaWSyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, monstr@seznam.cz wrote:
> We have there still problem with syscalls and we don't have chance to 
> fix it to stable version, this is not part which I can do yourself. 
> Microblaze will be n + 1 platform which use some old syscalls. 
> I hope you understand.

That still leaves the problem that a lot of your syscalls have bugs
copied from other platforms. If you need to maintain backwards compatibility
with your existing binaries, that's fine, but please fix the code you are
adding.

	Arnd <><
