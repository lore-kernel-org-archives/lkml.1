Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZBPMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZBPMN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZBPMNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:13:16 -0500
Received: from homer.mvista.com ([63.81.120.155]:58136 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754472AbZBPMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:13:16 -0500
Message-ID: <49995856.0@ru.mvista.com>
Date: Mon, 16 Feb 2009 15:13:10 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] ide: use ->tf_read in ide_read_error()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213458.13202.77992.sendpatchset@localhost.localdomain> <4998A37D.3040904@ru.mvista.com>
In-Reply-To: <4998A37D.3040904@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> * Add IDE_TFLAG_IN_FEATURE taskfile flag for reading Feature
>>   register and handle it in ->tf_read.
>>   
>
>  Doesn't seem like a good name -- you can't read the features 
> register. I should've commented to this patch earlier, of course...

   Moreover, the error register shoudn't be affeceted by the HOB bit, so 
this flag doesn't make sense.

MBR, Sergei


