Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132Ab0ATTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0ATTfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118Ab0ATTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:35:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53110 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0ATTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BlgRAWtdEOg52hH5HLIFkXvpdKhO/1ck50wC/QLfAj/darCAfqBnZreyJowIigod0Y
         nv7EfYM+yp3ZBPgESEZyeedyF+e06vaEwpyJdPLqzgBgy+Ui4zhAGuD7WKGBkYuyd7XC
         jbVThdfzqDOe0rBAsFQBIzrCoyaeLaPcRj0G0=
Message-ID: <4B575AF1.5020607@pobox.com>
Date: Wed, 20 Jan 2010 14:35:13 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bart Hartgers <bart.hartgers@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [patch 1/2] sata_via: Correctly setup PIO/DMA for pata slave
 on vt6421.
References: <20100116235653.898098245@gmail.com> <20100116235849.969478053@gmail.com>
In-Reply-To: <20100116235849.969478053@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 06:56 PM, Bart Hartgers wrote:
> Before only the timings for master were set. Datasheet can be found
> here: ftp://ftp.vtbridge.org/Docs/Storage/DS_VT6421A_100_CCPL.PDF
> Surprisingly, a slave drive works without this patch. According to the
> datasheet, the controller by default derives the DMA mode from the
> Set Features command issued to a drive. Not sure about the PIO
> timings, though. The real problem is that the timings for the master
> effectively are the ones tuned for the slave. If these support
> different UDMA-settings, there is trouble, especially when the slave
> supports a higher UDMA than the master.
>
> Anyhow, using the same mechanism for both master and slave seems like
> a good idea.
>
> Signed-off-by: Bart Hartgers<bart.hartgers@gmail.com>

applied


