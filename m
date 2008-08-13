Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbYHMORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbYHMORN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYHMOQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:16:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:18753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbYHMOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=WjsRNm+z7Qm8U0d9li5cZ1HOya8Bj1Feq7F9KsD4C/BvzbfQLXyfgAJuhBVV+STYIl
         g0FEFZg9NU4fhnx4JL+mhrc7JvD9hfVRwHamQ1pIWaxsyVRBHZ6L9pqHg1H+vwzbjs1o
         UdWowGpat4zyuZkFgxXHKYFbvy8xKbowx+DX8=
Subject: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when using C2
	and deeper sleep states (Dell Latitude XT)]
From: Milan Plzik <milan.plzik@gmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1218625125.4304.7.camel@localhost>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 16:16:20 +0200
Message-Id: <1218636980.5250.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello again,

On St, 2008-08-13 at 12:58 +0200, Milan Plzik wrote:
> I apologize for replying on my own mail (and also for top-posting, but
> this information is global update, not exactly fitting any of topics
> mentioned below).
> 
>   After playing for a longer while I found out that the system ends
> sometimes in state where, in order to do anything useful, I need to
> press keys on keyboard. Otherwise, the system just stalls and does
> nothing. I have no idea why does this happen (especially when I know
> that OHCI or wireless network adapter produce fair amount of
> interrupts). My /proc/interrupts is below. Just for the record,
> chipset
> on board is ATI RS600 with (apparently from lspci) ATI SB600
> southbridge.

  it looks like this problem disappears if CONFIG_CPU_IDLE option is
disabled, system seems to be stable for more than one hour. This
suggests that something may be wrong with the CPU_IDLE code. I can not
spend much more time by debugging the kernel, but if anyone has an
suggestion about what to fix, I will gladly test it. 

  Best regards,
	Milan Plzik

