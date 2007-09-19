Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbXISRS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbXISRS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXISRSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:18:47 -0400
Received: from baikonur.stro.at ([213.239.196.228]:4161 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXISRSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:18:46 -0400
Date: Wed, 19 Sep 2007 19:18:41 +0200
From: maximilian attems <max@stro.at>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       mchan@broadcom.com, vda.linux@googlemail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: bnx2 dirver's firmware images
Message-ID: <20070919171841.GT19918@baikonur.stro.at>
References: <46F01BDE.6020902@zytor.com> <20070918.122034.83625273.davem@davemloft.net> <46F02688.8030507@zytor.com> <20070918.130810.78161599.davem@davemloft.net> <20070918203530.GC27836@uranus.ravnborg.org> <20070919171033.GH6618@stro.at> <46F15886.6040701@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F15886.6040701@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:12:38AM -0700, H. Peter Anvin wrote:
> 
> Could you give a concrete example?
> 
> 	-hpa

max@dual:~/src/klibc$ touch usr/utils/mount_main.c
max@dual:~/src/klibc$ make
  KLIBCCC usr/utils/mount_main.o
  KLIBCLD usr/utils/static/halt
  LN      usr/utils/static/reboot
  LN      usr/utils/static/poweroff
  KLIBCLD usr/utils/shared/halt
  LN      usr/utils/shared/reboot
  LN      usr/utils/shared/poweroff
  KLIBCLD usr/utils/static/chroot
  KLIBCLD usr/utils/static/dd
  <snipp>

-- 
maks
