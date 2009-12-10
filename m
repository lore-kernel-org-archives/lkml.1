Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbZLJTQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbZLJTQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761367AbZLJTQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:16:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:50972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761205AbZLJTQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:16:43 -0500
Message-ID: <4B214874.9030909@kernel.org>
Date: Thu, 10 Dec 2009 11:13:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <adaocm6n02h.fsf@roland-alpha.cisco.com> <20091210184429.GO8742@kernel.dk>
In-Reply-To: <20091210184429.GO8742@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Dec 10 2009, Roland Dreier wrote:
>>  > mptable mpc is [12 - f011]
>>
>>  > what a BIOS !
>>
>> Can you be more explicit about what the BIOS is doing wrong?  

esp when the mpc is about 64k. should put it in [xxxx, 0x100000), and reserve it in e820

YH
