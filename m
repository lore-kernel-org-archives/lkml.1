Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYJOSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYJOSx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJOSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:53:18 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:39236 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbYJOSxR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:53:17 -0400
From: Frans Pop <elendil@planet.nl>
To: sfstudio@mail.ru
Subject: Re: Re: Re: patch to 2.6.27 fix build rpm
Date: Wed, 15 Oct 2008 20:53:12 +0200
User-Agent: KMail/1.9.9
Cc: gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081015172412.GB20222@localhost> <20081015172412.GB20222@localhost> <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
In-reply-To: <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810152053.13629.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2008 18:53:14.0249 (UTC) FILETIME=[4729C790:01C92EF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Евгений Маначкин wrote:
>   echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
>  +echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
>   echo "%else"
>   echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
>  +echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'

Is it really necessary to make the first directory twice in both cases?

I would suggest changing the patch to simply:
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'

Or even adding the creation of the firware dir to the original mkdirs.

Cheers,
FJP
