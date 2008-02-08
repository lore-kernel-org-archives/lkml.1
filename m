Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbYBHRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbYBHRWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbYBHRWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:22:12 -0500
Received: from homer.mvista.com ([63.81.120.155]:60876 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759088AbYBHRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:22:09 -0500
Message-ID: <47AC8FF5.4010204@ru.mvista.com>
Date: Fri, 08 Feb 2008 20:23:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] ide: fix ide_find_port()
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain> <20080208004434.17746.33986.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004434.17746.33986.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Instead of checking for '->io_ports[IDE_DATA_OFFSET] == 0' check for
>   '->chipset == ide_unknown' when looking for an empty ide_hwifs[] slot.

> * Do ide-pnp initialization after ide-generic when IDE is built-in
>   (ide-pnp is the only user of ide_find_port() which needs such fixup).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
