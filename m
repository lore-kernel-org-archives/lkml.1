Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZJWN7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZJWN7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJWN7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:59:33 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35793 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZJWN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TH+l9CJAuzCwsP/A5hKC9FLv/hYKxSxegexyIbGd3cMnNlOQ4oSqE3rSdYg0gZaQUL
         qQcw80xkDRFEb4gfbU+QY5ytZl5GccGYjeNCcF/o80hCI4jYSEupng1pAHD3OsuX3mNd
         kUVmMUQMztiK18P1gAKYPy61sPWWA01h6YRRE=
Message-ID: <4AE1B928.9020001@gmail.com>
Date: Fri, 23 Oct 2009 16:09:44 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] v4l: Cleanup redundant tests on unsigned
References: <4AE18C9E.9090409@gmail.com>
In-Reply-To: <4AE18C9E.9090409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 23-10-09 12:59, Roel Kluin schreef:
> The variables are unsigned so the test `>= 0' is always true,
> the `< 0' test always fails. In these cases the other part of
> the test catches wrapped values.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---

I forgot the stats:

 drivers/media/common/tuners/tda9887.c           |    2 +-
 drivers/media/dvb/siano/smscoreapi.c            |    2 +-
 drivers/media/video/bt819.c                     |    2 +-
 drivers/media/video/hexium_gemini.c             |    2 +-
 drivers/media/video/hexium_orion.c              |    2 +-
 drivers/media/video/mxb.c                       |    2 +-
 drivers/media/video/s2255drv.c                  |    2 +-
 drivers/media/video/saa7110.c                   |    2 +-
 drivers/media/video/saa717x.c                   |    2 +-
 drivers/media/video/tuner-core.c                |    2 +-
 drivers/media/video/usbvision/usbvision-video.c |    2 +-
 drivers/media/video/vpx3220.c                   |    2 +-
 drivers/media/video/zoran/zoran_driver.c        |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

