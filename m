Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZD3TnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZD3TnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZD3TnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:43:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZD3TnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:43:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "mark skuse" <mskuse@iname.com>
Subject: Re: difference between ppc and powerpc branches....
Date: Thu, 30 Apr 2009 21:42:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090430172803.A3EC41BF3DA@ws1-10.us4.outblaze.com>
In-Reply-To: <20090430172803.A3EC41BF3DA@ws1-10.us4.outblaze.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904302142.57124.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/7uz3CZaNQsKFYjTd41EBiRn24v8UYOrormsJ
 u+rK4eZ2olZAFcqyI5u0qAEPWSBi5ILmYh4oNvs1xv+0g3Jn5k
 e2It3RkOjS+aED1DuGiHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, mark skuse wrote:
> Sorry if this is a stupid question.. but could someone please
> give a brief description of the difference between the ppc and
> powerpc branches?  Spent a fair amount of time (not enough?)
> digging around but couldn't really find a clear answer...   

Very easy: ppc was the old name for the now discontinued 32-bit
PowerPC architecture, powerpc is the name for the merged 32 and
64 bit PowerPC architectures.

All recent kernel versions only have powerpc, and no active
development had gone into the ppc tree for a few years before.
The only reason for keeping ppc around was that some platforms
had not yet been ported to powerpc.

	Arnd <><
