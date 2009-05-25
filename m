Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZEYID1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZEYID1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZEYIDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:03:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZEYIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:03:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 15/32] union-mount: Documentation
Date: Mon, 25 May 2009 09:03:07 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-16-git-send-email-jblunck@suse.de> <8417.1243232743@jrobl>
In-Reply-To: <8417.1243232743@jrobl>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200905250903.08165.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19zpgn2Gklq1FgC9r3aN1L90Le4IZMUkZygbyy
 XQnVukZCVROCN+1i4PZAIwVQNl74JhWaO0xcge+coCtpnn/D56
 PKWBtOrQYtby3yUl0JWeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, hooanon05@yahoo.co.jp wrote:
> Is renaming a regular file supported?
> Accrding to the change in "[PATCH 24/32] union-mount: in-kernel file
> copy between union mounted filesystems", every rename under union seems
> to be rejected.

Right, but that is consistent with how the kernel would treat a
rename from one mount point to another, and tools like 'mv'
can handle this in user space.

	Arnd <><
