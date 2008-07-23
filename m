Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYGWPw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYGWPw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYGWPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:52:19 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1721 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYGWPwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:52:18 -0400
Message-ID: <488753AE.9020706@xs4all.nl>
Date: Wed, 23 Jul 2008 17:52:14 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: TD structure error TDindex=e
References: <48835302.1090708@xs4all.nl> <20080720160812.GA23652@electric-eye.fr.zoreil.com> <48836EB3.3050707@xs4all.nl> <20080720171440.GB23278@electric-eye.fr.zoreil.com>
In-Reply-To: <20080720171440.GB23278@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> :
>> Francois Romieu wrote:
>>> Can you apply the patch below to get some more information ?
>> Patch applied well.
>> Did come file transfers (recordings from MythTV via MythWeb). Worked Ok
>> until after a few files the system hang. No special logging, though:
>>
>> Jul 20 18:24:31 recorder ntpd[1524]: synchronized to 192.168.10.98,
>> stratum 1
>> Jul 20 18:24:48 recorder kernel: eth0: excessive work at interrupt.
>> Jul 20 18:26:44 recorder kernel: eth0: excessive work at interrupt.
> 
> Shit.
> 
> Can you apply the bandaid below too ?
> 
With that patch, so far, it doesn't hang. I transfered multiple GB's
from the EN12000 via it's MythTV web interface, receiving the data on my
workstation with wget.
I get transfers of ~40MB/s.
Transfers are 40+MB/s with some small pauses here and there.

I only see sometimes messages like kernel: eth0: excessive work at
interrupt. Not often.

Kind regards,
Udo
