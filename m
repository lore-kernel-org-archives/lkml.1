Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYECVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYECVH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYECVHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:07:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYECVHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:07:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 1/1] DEBUGFS: Fixing name for debug fs
Date: Sat, 3 May 2008 23:07:03 +0200
User-Agent: KMail/1.9.9
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
References: <monstr@seznam.cz> <1209825314-8048-1-git-send-email-monstr@seznam.cz> <c65b09261996cf3500b6faee201e2dd6c152973e.1209825194.git.monstr@monstr.eu>
In-Reply-To: <c65b09261996cf3500b6faee201e2dd6c152973e.1209825194.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805032307.04352.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Rh+HLz1NFoDQsbhieFYmEt+233WEhEslT9Nu
 FvEdZE9xRxFFpb+H3bQmaJx0bW4W5OZz/HPiT6trazla0rd/uH
 LqhO1t5fBbGbw5ZCtYbaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008, monstr@seznam.cz wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> This change is made because powerpc_debugfs_root is arch
> specific name.
...
>  
>  static int powerpc_debugfs_init(void)
>  {
> -       powerpc_debugfs_root = debugfs_create_dir("powerpc", NULL);
> +       debugfs_root = debugfs_create_dir("powerpc", NULL);
>  

You left the name as "powerpc", which sort of defeats the purpose of your
patch. Files in debugfs are by definition not part of the ABI, so it's
actually possible to change this as well. How about making this "of"
instead of "powerpc"?

	Arnd <><
