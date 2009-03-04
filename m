Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZCDScb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZCDScb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZCDScV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:32:21 -0500
Received: from ns2.mvista.com ([63.81.120.155]:34220 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753485AbZCDScV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:32:21 -0500
Message-ID: <49AEC951.8080609@ru.mvista.com>
Date: Wed, 04 Mar 2009 21:32:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/15] ide: add "flagged" taskfile flags to struct ide_taskfile
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain> <20090201175012.19144.87417.sendpatchset@localhost.localdomain> <20090206170425.201346e6.sfr@canb.auug.org.au> <200902081238.18970.bzolnier@gmail.com>
In-Reply-To: <200902081238.18970.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>Subject: [PATCH] ide: add "flagged" taskfile flags to struct ide_taskfile

>>>* Add ->ftf_flags field to struct ide_taskfile
>>>  and convert flags for TASKFILE ioctl to use it.

>>>* Rename "flagged" taskfile flags:
>>>  - IDE_TFLAG_FLAGGED -> IDE_FTFLAG_FLAGGED

>>There were several places where this transformation did not take place as
>>shown by today's linux-next build.

> Thanks, it is now fixed with v2 of the patch, interdiff below:

> ...
> v2:
> * Remember to fully update ide-h8300.c, scc_pata.c and tx493{8,9}ide.c
>   (thanks to Stephen Rothwell for noticing).

> There should be no functional changes caused by this patch.

> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
