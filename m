Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbYBTXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbYBTXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYBTXMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:12:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:64662 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbYBTXMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GZfpNhR/Jcmlv8LGgyPJ5KjvXcUgeL76S7tKBtjyVMOxlJYUQ/LogyZW/3oAzjN8864AIhNy2E21F3M5PivHoUmJES5mYv4MQuGJJlWGG4cDWfwx3yG0A3J8RhwO8IM/Xlt1riKPliqbCYWtOD3NOC2AeHf1g9ctzC2JV4FDvjo=
Message-ID: <47BCB3EB.1070308@gmail.com>
Date: Thu, 21 Feb 2008 00:12:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] moxa: make functions static
References: <1203545644.25307.40.camel@brick>
In-Reply-To: <1203545644.25307.40.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2008 11:14 PM, Harvey Harrison wrote:
> All were forward declared static already.
> 
> Fixes sparse warnings:
> drivers/char/moxa.c:1421:6: warning: symbol 'MoxaDriverInit' was not declared. Should it be static?
> drivers/char/moxa.c:1464:6: warning: symbol 'MoxaPortFlushData' was not declared. Should it be static?
> drivers/char/moxa.c:1477:5: warning: symbol 'MoxaDriverIoctl' was not declared. Should it be static?
> drivers/char/moxa.c:1604:5: warning: symbol 'MoxaDriverPoll' was not declared. Should it be static?
> drivers/char/moxa.c:1667:5: warning: symbol 'MoxaPortsOfCard' was not declared. Should it be static?
> drivers/char/moxa.c:1954:5: warning: symbol 'MoxaPortIsValid' was not declared. Should it be static?
> drivers/char/moxa.c:1964:6: warning: symbol 'MoxaPortEnable' was not declared. Should it be static?
> drivers/char/moxa.c:1987:6: warning: symbol 'MoxaPortDisable' was not declared. Should it be static?
> drivers/char/moxa.c:1997:6: warning: symbol 'MoxaPortGetMaxBaud' was not declared. Should it be static?
> drivers/char/moxa.c:2007:6: warning: symbol 'MoxaPortSetBaud' was not declared. Should it be static?
> drivers/char/moxa.c:2031:5: warning: symbol 'MoxaPortSetTermio' was not declared. Should it be static?
> drivers/char/moxa.c:2087:5: warning: symbol 'MoxaPortGetLineOut' was not declared. Should it be static?
> drivers/char/moxa.c:2107:6: warning: symbol 'MoxaPortLineCtrl' was not declared. Should it be static?
> drivers/char/moxa.c:2122:6: warning: symbol 'MoxaPortFlowCtrl' was not declared. Should it be static?
> drivers/char/moxa.c:2142:5: warning: symbol 'MoxaPortLineStatus' was not declared. Should it be static?
> drivers/char/moxa.c:2168:5: warning: symbol 'MoxaPortDCDChange' was not declared. Should it be static?
> drivers/char/moxa.c:2180:5: warning: symbol 'MoxaPortDCDON' was not declared. Should it be static?
> drivers/char/moxa.c:2193:5: warning: symbol 'MoxaPortWriteData' was not declared. Should it be static?
> drivers/char/moxa.c:2257:5: warning: symbol 'MoxaPortReadData' was not declared. Should it be static?
> drivers/char/moxa.c:2327:5: warning: symbol 'MoxaPortTxQueue' was not declared. Should it be static?
> drivers/char/moxa.c:2341:5: warning: symbol 'MoxaPortTxFree' was not declared. Should it be static?
> drivers/char/moxa.c:2355:5: warning: symbol 'MoxaPortRxQueue' was not declared. Should it be static?
> drivers/char/moxa.c:2370:6: warning: symbol 'MoxaPortTxDisable' was not declared. Should it be static?
> drivers/char/moxa.c:2378:6: warning: symbol 'MoxaPortTxEnable' was not declared. Should it be static?
> drivers/char/moxa.c:2387:5: warning: symbol 'MoxaPortResetBrkCnt' was not declared. Should it be static?
> drivers/char/moxa.c:2396:6: warning: symbol 'MoxaPortSendBreak' was not declared. Should it be static?

Thanks, but I have similar fixes for both issues you address in my tree. I'll 
post it in few days.
