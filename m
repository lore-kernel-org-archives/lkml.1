Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYBIRyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYBIRyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYBIRxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:53:49 -0500
Received: from h155.mvista.com ([63.81.120.155]:5269 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753467AbYBIRxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:53:48 -0500
Message-ID: <47ADE8DF.4090202@ru.mvista.com>
Date: Sat, 09 Feb 2008 20:54:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 1/3] ide-tape: remove never executed code
References: <200802091623.46896.bzolnier@gmail.com>
In-Reply-To: <200802091623.46896.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> rq->cmd[0] is never set to REQ_IDETAPE_READ_BUFFER so remove
> REQ_IDETAPE_READ_BUFFER handling from idetape_create_write_cmd()
> and the define itself.

> Then remove no longer used idetape_create_read_buffer_cmd()
> and IDETAPE_RETRIEVE_FAULTY_BLOCK define.

> There should be no functional changes caused by this patch.

> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
