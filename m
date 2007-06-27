Return-Path: <linux-kernel-owner+w=401wt.eu-S1760876AbXF0OB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760876AbXF0OB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXF0OBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:01:50 -0400
Received: from mailgw11.fraunhofer.de ([153.96.1.23]:57075 "EHLO
	mailgw11.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbXF0OBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:01:48 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 10:01:48 EDT
Date: Wed, 27 Jun 2007 15:58:43 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: sam@ravnborg.org
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
Message-ID: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Jun 2007 14:00:41.0890 (UTC) FILETIME=[8C835820:01C7B8C3]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Jun 25, 2007 at 04:53:55PM +0200, Joerg Schilling wrote:
> > 
> > star needs "ext2_fs.h". This file is not usable at all on many Linux 
> > distributions, even with GCC.
>
> I was curious so I did:
>
> $ mkdir ~/foo
> $ cd ~/kernel/linux-2.6
> $ make INSTALL_HDR_PATH=~/foo
> $ cd ~/foo
> $ cat j.c
> #include <stdio.h>
> #include "etx2_fs.h"
>
> main()
> {
> 	printf("helloo\n");
> }
>
> $ gcc -o j j.c
> => No warning, no errors
>

On Suse Linux 10.0, I get e.g.:

cat t.c
#include <stdio.h>
#include <linux/ext2_fs.h>

gcc -c t.c
In file included from /usr/include/linux/ext2_fs.h:20,
                 from t.c:2:
/usr/include/linux/ext2_fs_sb.h:40: error: syntax error before âuid_tâ
/usr/include/linux/ext2_fs_sb.h:49: error: syntax error before âs_next_generationâ
/usr/include/linux/ext2_fs_sb.h:51: error: syntax error before â*â token
/usr/include/linux/ext2_fs_sb.h:56: error: syntax error before â}â token

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
