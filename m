Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYLTCAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYLTCAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 21:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYLTCAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 21:00:08 -0500
Received: from main.gmane.org ([80.91.229.2]:50838 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYLTCAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 21:00:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O   support
 properly
Date: Fri, 19 Dec 2008 19:58:03 -0600
Message-ID: <494C512B.6090304@shaw.ca>
References: <494A5BBF.8000807@inf.tu-dresden.de>	<494A837A.50801@garzik.org> <20081218181015.2e160d5c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-ide@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081218181015.2e160d5c@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This seems like a risky assumption...
> 
> Its wrong on various counts
> 
> - ata_id_major_version can't tell early ATA versions apart
> - on anything later than the early ISA IDE paddles (the ones that
> basically were just bus decoders) its invisible to the drive
> 
> Except for legacy ISA bus controllers (and even there it is questionable)
> I would favour simply ignoring it.

32-bit IO wouldn't work on any ISA controller, would it? What happens if 
you do 32-bit IO port access on something on the ISA bus?

