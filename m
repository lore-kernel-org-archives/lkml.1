Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYKYBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYKYBC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYKYA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:57:06 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:63951 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbYKYA5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:57:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dj5QO91rQ89/3JcExThpNVYSCfYzvFdv91Meg5EkpCyzDEuHZ7IZJcXRyYhmoGmCHk
         QV3empg0fz2FTkHz2sZi4ah+2TyEo8Lx4oHMHpqLOq9yzCX+ie4Br/o3yt6I+aHM7eTR
         I8fG6lpXGKbc2VrJQ6gYVAYvKUexXYNJkNT2I=
Subject: Re: [PATCH] CRED: fix sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hannes Eder <hannes@hanneseder.net>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <154e089b0811241646y6ada2c97l5e45284969729e29@mail.gmail.com>
References: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
	 <5008.1227568869@redhat.com>
	 <154e089b0811241646y6ada2c97l5e45284969729e29@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 16:56:58 -0800
Message-Id: <1227574619.5511.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 01:46 +0100, Hannes Eder wrote:
> On Tue, Nov 25, 2008 at 12:21 AM, David Howells <dhowells@redhat.com> wrote:
> > Hannes Eder <hannes@hanneseder.net> wrote:
> >
> >>   security/security.c:228:2: warning: returning void-valued expression
> >>   security/security.c:233:2: warning: returning void-valued expression
> >>   security/security.c:616:2: warning: returning void-valued expression
> >
> > What's wrong with that?

Well, there's still a few left, I kind of stopped going after this
class of sparse warnings.

But if you're up to it:
mm/hugetlb.c:375:3: warning: returning void-valued expression
mm/hugetlb.c:408:3: warning: returning void-valued expression
fs/xfs/xfs_inode.h:326:2: warning: returning void-valued expression
security/security.c:228:2: warning: returning void-valued expression
security/security.c:233:2: warning: returning void-valued expression
security/security.c:616:2: warning: returning void-valued expression
drivers/ide/alim15x3.c:594:2: warning: returning void-valued expression
drivers/isdn/i4l/isdn_net.c:1981:3: warning: returning void-valued expression
drivers/rtc/rtc-ds1511.c:634:2: warning: returning void-valued expression
drivers/rtc/rtc-stk17ta8.c:403:2: warning: returning void-valued expression
drivers/video/nvidia/nv_accel.c:304:3: warning: returning void-valued expression
drivers/video/nvidia/nv_accel.c:323:3: warning: returning void-valued expression
drivers/video/via/viafbdev.c:871:3: warning: returning void-valued expression
drivers/video/via/viafbdev.c:938:3: warning: returning void-valued expression
drivers/video/via/viafbdev.c:995:3: warning: returning void-valued expression
drivers/video/pm3fb.c:543:3: warning: returning void-valued expression
drivers/video/neofb.c:1456:4: warning: returning void-valued expression
drivers/video/neofb.c:1464:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:305:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:331:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:370:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1497:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1525:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1544:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1558:3: warning: returning void-valued expression
sound/sound_core.c:460:2: warning: returning void-valued expression
sound/sound_core.c:477:2: warning: returning void-valued expression

Cheers,

Harvey

