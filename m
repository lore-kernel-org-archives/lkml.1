Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZEZXkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZEZXkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbZEZXkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:40:17 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:34981 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbZEZXkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=abICZzCic+BPbq+b3a8Hz7EufZD/OKdG9FrWs85mLtsykIZWIaUzuA6TudWoV6vmWn
         Bu2YVqxoy56LOE9W/HgbohkL6vreeOXBM5wAQCI0uppzFauZZOtP0VSjpqV6sNkyN3ZD
         kNgjlZYxRpjnh3lHj3gep2zcU97KcXreTs2eY=
Message-ID: <4A1C7DDB.9010605@gmail.com>
Date: Tue, 26 May 2009 17:40:11 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
 list    with different entry count [map count=13] [unmap count=10]
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
In-Reply-To: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
> CONFIG_DMA_API_DEBUG=y
> Since then I get the following or similar errors on each boot:

Please retest with a newer -rc, this patch likely fixes it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
