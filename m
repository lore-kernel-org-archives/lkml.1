Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbXIKRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbXIKRVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXIKRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:21:21 -0400
Received: from palrel13.hp.com ([156.153.255.238]:52168 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXIKRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:21:20 -0400
Message-ID: <46E6CE75.5040700@hp.com>
Date: Tue, 11 Sep 2007 10:20:53 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ed Swierk <eswierk@arastra.com>
Cc: netdev@vger.kernel.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configurable tap interface MTU
References: <e6c711510709110742v4d2da644ha63b0a6d47c1230b@mail.gmail.com>
In-Reply-To: <e6c711510709110742v4d2da644ha63b0a6d47c1230b@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Swierk wrote:
> This patch makes it possible to change the MTU on a tap interface.
> Increasing the MTU beyond the 1500-byte default is useful for
> applications that interoperate with Ethernet devices supporting jumbo
> frames.
> 
> The patch caps the MTU somewhat arbitrarily at 16000 bytes. This is
> slightly lower than the value used by the e1000 driver, so it seems
> like a safe upper limit.

FWIW the OFED 1.2 bits take the MTU of IPoIB up to 65520 bytes :)

rick jones
