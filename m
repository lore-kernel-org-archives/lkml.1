Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXHZXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXHZXd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXHZXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 19:33:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:23505 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXHZXdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 19:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LYHrZ/V5vBStABCUiqliT7r82bWLsFAYyteCNRdh8gCJYgP+aTPk8AwPvlp2KB297rruIuSyAdd9pIFqv7TAa2lGgAczzADLU/y4jiChC3kjfWPEV2KSiIoUftgjoDgJdP2cbPdOKeft4fsaDJO+DgQzbvie09gccRDKMWw2eoQ=
Message-ID: <6bffcb0e0708261633r5de8296di53aca3def4ebbdcd@mail.gmail.com>
Date: Mon, 27 Aug 2007 01:33:17 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "fredoxygene@free.fr" <fredoxygene@free.fr>
Subject: Re: PROBLEM: kernel BUG at kernel/workqueue.c:323!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1188125967.46d15d0f87c01@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188125967.46d15d0f87c01@imp.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/08/07, fredoxygene@free.fr <fredoxygene@free.fr> wrote:
> PROBLEM: kernel BUG at kernel/workqueue.c:323!
>
> Summary :
> Happened while i was transferring a huge amount of data on wifi (ipw3945).
> Computer is a Fujitsu/Siemens Si 1520 / T5500, running Unbuntu Feisty 7.04.
>
> Follows :
> - dmesg output with "kernel bug"
> - scripts/ver_linux output
> - others thinks like lspci -vvv, etc...
>
> Feel free to ask i you need some more details or if i can help (by doing some
> testings or other stuffs)
>
> dmesg output :
> [  178.752000] ieee80211_crypt: registered algorithm 'TKIP'
> [  196.120000] eth1: no IPv6 routers present
> [ 1548.228000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
> [ 1548.924000] ipw3945: Error sending cmd #07 to daemon: time out after 500ms.
> [ 1550.524000] ipw3945: Error sending SCAN_ABORT_CMD: time out after 500ms.
> [ 1551.024000] ipw3945: Error sending cmd #08 to daemon: time out after 500ms.
> [ 1551.524000] ipw3945: Error sending ADD_STA: time out after 500ms.
> [ 1552.024000] ipw3945: Error sending SCAN_ABORT_CMD: time out after 500ms.
> [ 1561.536000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
> [ 1561.712000] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 1582.928000] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 1611.024000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
> [ 1611.524000] ipw3945: Error sending LEDS_CMD: time out after 500ms.
> [ 1611.796000] ------------[ cut here ]------------
> [ 1611.796000] kernel BUG at kernel/workqueue.c:323!

"Problems building with kernel v2.6.20
The work queue structure changed with 2.6.20. In addition,
pci_module_init was deprecated. The three patches below in Patches
were provided by Mattiaa Dongili to correct this behavior. Download
them and apply them to ipw3945-1.1.3 James"

http://ipw3945.sourceforge.net/

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
