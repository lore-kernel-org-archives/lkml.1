Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYGRRpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYGRRpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYGRRpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:45:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYGRRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:45:14 -0400
Message-ID: <4880D684.7020406@zytor.com>
Date: Fri, 18 Jul 2008 10:44:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       jbarnes@virtuousgeek.org, Jack Howarth <howarth@bromo.msbb.uc.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
References: <200807180941.09779.yhlu.kernel@gmail.com>
In-Reply-To: <200807180941.09779.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> change the mconf bus range from [0,0xff] to to [0, 0x3f]
> to match range [0xf0000000, 0xf4000000) in e820 tables.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Tested-by: Jack Howarth <howarth@bromo.msbb.uc.edu>

Why is this hard-coded instead of discovered dynamically?

	-hpa
