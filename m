Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYHBNDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYHBNDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYHBNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:03:39 -0400
Received: from userg501.nifty.com ([202.248.238.81]:58753 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYHBNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:03:38 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=Gi421gf2914QctNxie/KZnaKZjD6CgixmCOx7uRzZUhs5Sk/FudChnP+MmFO98UhJ
	nO6cMVMFaFYUfFRypnhqw==
X-Nifty-SrcIP: [219.116.19.242]
Date: Sat, 2 Aug 2008 21:58:50 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Subject: RE: GPL / MPL license issues.
Message-Id: <20080802215850.f9bd1beb.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for reply to 1-year-old message.

I heard original developer of these code (David Hinds)
have agreed to change the license to GPL. 


Best Regards
Komuro

>List:       linux-kernel
>Subject:    GPL / MPL license issues.
>From:       Dave Jones <davej () redhat ! com>
>Date:       2007-08-07 20:27:58
>
>There are a number of files in the kernel that have in their
>headers a notice that the file is under the Mozilla Public License,
>which alone, is incompatible with the GPL.
>
>This itself is fine, as long as the resulting code claims
>to be Dual MPL/GPL, however there are a few cases where this
>doesn't seem to be happening.
>
>drivers/pcmcia/soc_common.c gets linked into
>drivers/pcmcia/pxa2xx_core.o, which seems to end up with
>a module license of "GPL".
>
>ricoh.h and o2micro.h are MPL, yet get included in
>drivers/pcmcia/yenta_socket.c which ends up as a "GPL" module.
>
>drivers/pcmcia/i82365.h is MPL, yet gets included in the following
>GPL only drivers ..
> drivers/pcmcia/i82092.c
> drivers/pcmcia/pd6729.c
> drivers/pcmcia/vrc4171_card.c
> drivers/pcmcia/yenta_socket.c
>
>drivers/pcmcia/pd6729.c is MODULE_LICENSE("GPL"), yet includes
>the MPL'd 'cirrus.h'
>
>drivers/serial/serial_cs.c labels itself as MPL/GPL, yet
>has a MODULE_LICENSE("GPL").
>
>drivers/scsi/pcmcia/qlogic_stub.c does the same.
>
>I may have missed some others, but this is what turned up from
>some simple grepping.
>
>I've got patches fixing up some of the simpler cases changing
>the "GPL" to "Dual MPL/GPL", but I want to be sure I'm not
>barking up the wrong tree first.
>
>comments?
>
>	Dave
