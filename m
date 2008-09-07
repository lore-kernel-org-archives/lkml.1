Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYIGSsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYIGSsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYIGSsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:48:37 -0400
Received: from h155.mvista.com ([63.81.120.155]:17987 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754108AbYIGSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:48:36 -0400
Message-ID: <48C4222A.6000506@ru.mvista.com>
Date: Sun, 07 Sep 2008 22:49:14 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] ide: add ->read_sff_dma_status method
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <48BE8EFD.70103@ru.mvista.com> <200809032013.08489.bzolnier@gmail.com> <48C41A2E.8040907@ru.mvista.com>
In-Reply-To: <48C41A2E.8040907@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>    Hm, I guess I'm seeing a real issue

    Nevermind, it's just ide_read_sff_dma_status() used for hwif->tp_ops-> 
read_sff_dma_status() method in the driver where it clearly doesn't make 
sense.  But it seems it never gets called in these cases anyway (only adds a 
confusion :-).

> with this patch...

    Not with this patch actually, with the one that introduced 'struct tp_ops'.

>> Thanks,
>> Bart

MBR, Sergei
