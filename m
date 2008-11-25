Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYKYQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYKYQAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKYQAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:00:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:54201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYKYQAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:00:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [Patch 0/3] OProfile SPU event profiling support for IBM Cell processor
Date: Tue, 25 Nov 2008 17:00:30 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
References: <1227568781.6509.198.camel@carll-linux-desktop>
In-Reply-To: <1227568781.6509.198.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811251700.30926.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VdaYRhUiRREQ/leS5fYKZm47R8vwxQmtJNi5
 PjBKXNXrTOeqk70s5wF5SKNjOtbpoz70C/tMSkMqREBEIY+HWe
 1mZs4vP59vP4xNDN2BDoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008, Carl Love wrote:
> This patch set consists of two kernel patches and one user level patch
> to add SPU event based profiling support to OProfile for the IBM Cell
> processor.  The first patch in the series is the user level patch that
> adds the needed events and event checking to the user tool.  The second
> patch is the first of two kernel patches.  It makes some structural
> changes to the kernel code to make it easier to add the specific
> functions for doing SPU event profiling.  The first kernel patch does
> not make any functional changes.  The third patch in the series is the
> second kernel patch where the actual SPU event profiling code support is
> added to the kernel.

Thanks for your submission!

I can't comment on the oprofile user code, but I have some comments
on the implementation in the third patch.

Are the patches interdependent, or will old versions of the oprofile
tool work with new kernels and vice versa?

	Arnd <><
