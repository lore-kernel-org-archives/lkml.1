Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYHULj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYHULj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbYHULjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:39:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58716 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYHULjm (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:39:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Date: Thu, 21 Aug 2008 13:39:36 +0200
User-Agent: KMail/1.9.9
Cc: carsteno@de.ibm.com, jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-15?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       nickpiggin@yahoo.com.au
References: <48AD00F8.1030004@gmail.com> <48AD2AFF.5060609@de.ibm.com> <1219308560.2988.247.camel@pmac.infradead.org>
In-Reply-To: <1219308560.2988.247.camel@pmac.infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211339.37187.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18pTWFhhitotSZhUrjf7n8zXi/RBmS3//oyrrb
 b/0RyQyjWvAG6iBZ9KGaacZI+w485BgXjdbLPKiVvVz3eLfkrK
 /2Y/bbbUlBQ+fodqopysQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, David Woodhouse wrote:
> On Thu, 2008-08-21 at 10:44 +0200, Carsten Otte wrote:
> >
> > Exporting profiling data for a file system in another file system 
> > (/proc) seems not very straigtforward to me. I think it is worth 
> > considering to export this information via the same mount point.
> 
> I would have said sysfs, rather than 'the same mount point'.
> 

Let me throw in debugfs as my preferred option. sysfs is for stable
interfaces, while profiling generally fits into the debugging category.

	Arnd <><
