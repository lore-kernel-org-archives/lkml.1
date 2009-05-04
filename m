Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZEDOcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZEDOcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZEDOcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:32:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZEDOcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:32:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Subject: Re: [PATCH 00/27] more non-ABI asm-generic headers
Date: Mon, 4 May 2009 16:32:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <10f740e80905030417m3b67da38uecd6bd008b4c7e3f@mail.gmail.com>
In-Reply-To: <10f740e80905030417m3b67da38uecd6bd008b4c7e3f@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905041632.28026.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ACGBuYORFGVu1b79TG11+1PX/qQRpSTGrs9r
 EiuuieEroqHhN2QMY+lRVy9HHYCdO3/RsQ6sihJACH1yyjHmBX
 d6Wonq3sEjeXlR6lxNNJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Geert Uytterhoeven wrote:
> On Thu, Apr 30, 2009 at 17:34, Arnd Bergmann <arnd@arndb.de> wrote:
> > To avoid trouble with quilt mail, I'm now trying
> > git-format-patch to generate them, hopefully this
> > works a little better. Can anyone tell me why I can't
> > add a 'To' header rather than just 'Cc' in
> > git-format-patch?
> 
> I always specify the --to with git send-email.

I haven't tried using git send-email yet, because it does not let
me inspect mails after changing the headers but before sending
them out.

I have now gone back to my old method of

rm -rf patches
mkdir -p patches
git-format-patch -o patches | cut -f 2- -d/ > patches/series
quilt mail --mbox ~/Mail/outbox
#manually edit outbox if necessary, then hit send button in mail client.

	Arnd <><
