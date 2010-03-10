Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0CJQa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:30:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41856 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab0CJQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=alXm6IeRtoOM9aUi47cY7ZpI4mH7fbL88AHV+QldTkB6+0+4h9MjPhLWhkmYBXDaB2
         jY+dM8p7P28sLSw+AWL1AD78FxK8r57GcxyRO6jx6eW7Rx5W9SRDcZ0ss8K4EXycqv/v
         5b3JQiV2odopoaNBbPTbLapHjM53RqDqhPTh4=
Message-ID: <4B97C93B.9050002@garzik.org>
Date: Wed, 10 Mar 2010 11:30:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ata1 timeouts on 2.6.34-rc1
References: <40a4ed591003100208v67b61ca5sd7a3ab8da99e975e@mail.gmail.com>	 <4B97AD5B.5080802@garzik.org> <40a4ed591003100741i3f62c180k99fc85b2c57ab210@mail.gmail.com>
In-Reply-To: <40a4ed591003100741i3f62c180k99fc85b2c57ab210@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2010 10:41 AM, Zeno Davatz wrote:
> Mar 10 13:30:01 zenogentoo cron[12528]: (root) CMD (test -x
> /usr/sbin/run-crons&&  /usr/sbin/run-crons )
> Mar 10 13:33:32 zenogentoo sudo:     zeno : TTY=pts/0 ; PWD=/home/zeno
> ; USER=root ; COMMAND=/usr/bin/emerge --sync
> Mar 10 13:33:48 zenogentoo ata1: clearing spurious IRQ
> Mar 10 13:34:19 zenogentoo ata1: lost interrupt (Status 0x50)
> Mar 10 13:34:19 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x6 frozen
> Mar 10 13:34:19 zenogentoo ata1.00: failed command: READ DMA
> Mar 10 13:34:19 zenogentoo ata1.00: cmd
> c8/00:08:d5:20:cb/00:00:00:00:00/e9 tag 0 dma 4096 in
> Mar 10 13:34:19 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
> Emask 0x4 (timeout)
> Mar 10 13:34:19 zenogentoo ata1.00: status: { DRDY }
> Mar 10 13:34:19 zenogentoo ata1: soft resetting link
> Mar 10 13:34:19 zenogentoo ata1.00: configured for UDMA/133
> Mar 10 13:34:19 zenogentoo ata1.00: device reported invalid CHS sector 0
> Mar 10 13:34:19 zenogentoo ata1: EH complete
> Mar 10 13:35:55 zenogentoo ata1: clearing spurious IRQ
> Mar 10 13:36:26 zenogentoo ata1: lost interrupt (Status 0x50)
> Mar 10 13:36:26 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x6 frozen
> Mar 10 13:36:26 zenogentoo ata1.00: failed command: WRITE DMA
> Mar 10 13:36:26 zenogentoo ata1.00: cmd
> ca/00:10:1d:ad:52/00:00:00:00:00/e6 tag 0 dma 8192 out
> Mar 10 13:36:26 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
> Emask 0x4 (timeout)
> Mar 10 13:36:26 zenogentoo ata1.00: status: { DRDY }
> Mar 10 13:36:26 zenogentoo ata1: soft resetting link
> Mar 10 13:36:26 zenogentoo ata1.00: configured for UDMA/133
> Mar 10 13:36:26 zenogentoo ata1.00: device reported invalid CHS sector 0
> Mar 10 13:36:26 zenogentoo ata1: EH complete
> Mar 10 13:40:01 zenogentoo cron[12707]: (root) CMD (test -x
> /usr/sbin/run-crons&&  /usr/sbin/run-crons )
> Mar 10 13:48:05 zenogentoo sudo:     zeno : TTY=pts/0 ; PWD=/home/zeno
> ; USER=root ; COMMAND=/usr/bin/emerge portage
> Mar 10 13:49:22 zenogentoo ata1: clearing spurious IRQ
> Mar 10 13:49:53 zenogentoo ata1: lost interrupt (Status 0x50)
> Mar 10 13:49:53 zenogentoo ata1.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x6 frozen
> Mar 10 13:49:53 zenogentoo ata1.00: failed command: WRITE DMA
> Mar 10 13:49:53 zenogentoo ata1.00: cmd
> ca/00:08:05:21:df/00:00:00:00:00/ef tag 0 dma 4096 out
> Mar 10 13:49:53 zenogentoo res 40/00:00:00:00:00/00:00:00:00:00/00
> Emask 0x4 (timeout)
> Mar 10 13:49:53 zenogentoo ata1.00: status: { DRDY }
> Mar 10 13:49:53 zenogentoo ata1: soft resetting link
> Mar 10 13:49:53 zenogentoo ata1.00: configured for UDMA/133
> Mar 10 13:49:53 zenogentoo ata1.00: device reported invalid CHS sector 0
> Mar 10 13:49:53 zenogentoo ata1: EH complete
>
> Let me know if I can supply you with anymore information. Also see
> attached lspci-v file.
>


need full dmesg from boot, not just error snippet.

	Jeff

