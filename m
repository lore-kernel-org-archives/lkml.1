Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGJPxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGJPxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZGJPxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:53:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63375 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZGJPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZdjnImS1q42MXY2OvPjOMw/1hddYDkZ6M5u1kL0ZtVl5ETfx8CEjA9coDdpuGnD3vv
         homePk61iIGBGI3qXV9mqJcPscOZhq6lktzpZ4SUWscrC+lJmsoglv26shMHVJDx39F5
         3qe0+NbC8YsIDA/5bbGKbdLsZ/hnJdCCSR6gU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 3/3] staging/rt*: don't confuse user of rt3070 driver with rt2870 strings
Date: Fri, 10 Jul 2009 17:58:35 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090708-03666-gb620e95-dirty; KDE/4.2.4; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <4A54FC7E.1020902@gmail.com>
In-Reply-To: <4A54FC7E.1020902@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907101758.36601.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009 22:07:26 Marcin Slusarz wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH 3/3] staging/rt*: don't confuse user of rt3070 driver with rt2870 strings
> 
> Original author didn't bother to change strings for rt3070 driver. Fix it.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

for all three patches

> Next steps could be:
> - removal of loading configuration from kernel
> - removal of driver "versions"

- finishing unification of rt{28,30}70sta drivers (shouldn't be difficult,
  as it mostly requires replacing ifdefs with chipsets version checks and
  checking the end result with the hardware)

- finishing unification of rt28{6,7}0sta drivers (similar complexity)

> Bart, are you preparing some patches for these drivers?

Not at the moment and I would prefer to make some overdue changes
to rtl8187se, rtl8192su and rt3090 first anyway..
