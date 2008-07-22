Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYGVCVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYGVCVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYGVCVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:21:25 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2371 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYGVCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:21:24 -0400
Message-ID: <4885440C.8000109@linuxtv.org>
Date: Mon, 21 Jul 2008 22:21:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] dvb/siano/: cleanups
References: <20080721193344.GE14846@cs181140183.pp.htv.fi>
In-Reply-To: <20080721193344.GE14846@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

Please see my pull request, below.

Adrian Bunk wrote:
> This patch contains the following cleanups:
> - mark smscore_module_init() as __init
> - mark smscore_module_exit as __exit
> - make the following needlessly global code static:
>   - smscoreapi.c: struct g_smscore_notifyees
>   - smscoreapi.c: struct g_smscore_devices
>   - smscoreapi.c: struct g_smscore_deviceslock
>   - smscoreapi.c: struct g_smscore_registry
>   - smscoreapi.c: struct g_smscore_registrylock
>   - smscoreapi.c: smscore_module_init()
>   - smscoreapi.c: smscore_module_exit()
>   - smsdvb.c: struct g_smsdvb_clients
>   - smsdvb.c: struct g_smsdvb_clientslock
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  drivers/media/dvb/siano/smscoreapi.c |   14 +++++++-------
>  drivers/media/dvb/siano/smsdvb.c     |    4 ++--
>  2 files changed, 9 insertions(+), 9 deletions(-)
>   
Thank you for this, Adrian.  I've pushed this into my tree.

Mauro,

Please pull from:

http://linuxtv.org/hg/~mkrufky/sms1xxx

for:

- sms1xxx: dvb/siano/: cleanups

 smscoreapi.c |   14 +++++++-------
 smsdvb.c     |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

Regards,

Mike
