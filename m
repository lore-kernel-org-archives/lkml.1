Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab0BJP75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:59:57 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:52321 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0BJP7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nz2WcBy6+XdmpGWefPqQSZAB7UM6H6pPTEON+iohtdvy76BQpPEWAEE3t3Pao1SPwq
         3gomuA9TtL88TYDaLcW5J29UUAFab/wunfy47q8Q+4t8SgxIMEgYe6Lhz+uD8RaSEgJe
         1TVPW/TOYW9UBGrZWuQ5e/DF2g5htokcy+jmA=
MIME-Version: 1.0
In-Reply-To: <445R0ey9hAI.A.4VB.YozbLB@chimera>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
	 <445R0ey9hAI.A.4VB.YozbLB@chimera>
Date: Wed, 10 Feb 2010 16:59:52 +0100
Message-ID: <68676e01002100759v37f79938p51f3aeb6c068d39a@mail.gmail.com>
Subject: Re: [Bug #15195] kernel BUG at include/net/netns/generic.h:41, 
	pfkey_create+0x36/0x18b [af_key]
From: Luca Tettamanti <kronos.it@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 11:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15195
> Subject         : kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
> Submitter       : Luca Tettamanti <kronos.it@gmail.com>
> Date            : 2010-01-30 13:23 (9 days old)
> References      : http://marc.info/?l=linux-netdev&m=126485785004775&w=4
> Handled-By      : Alexey Dobriyan <adobriyan@gmail.com>
> Patch           : http://patchwork.kernel.org/patch/75891/

Fixed by commit 180211b841b5bf13ab10d19202adab3eb7749f6c

Luca
