Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYC2RUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYC2RUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYC2RUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:20:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52561 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYC2RUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:20:43 -0400
Message-ID: <47EE7A66.30905@zytor.com>
Date: Sat, 29 Mar 2008 10:20:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jacek Luczak <difrost.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Comma at end of enum lists
References: <47EE75A0.8070705@gmail.com>
In-Reply-To: <47EE75A0.8070705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacek Luczak wrote:
> Hi All,
> 
> I've found that in many enum lists, there's a comma at the end, e.g. 
> (arch/x86/kernel/early_printk.c):
> 
> enum {
>         MAGIC1 = 0xBACCD00A,
>         MAGIC2 = 0xCA110000,
>         XOPEN = 5,
>         XWRITE = 4,
> };
> 
> Just out of curiosity, is there any particular reason here (no word in 
> CodingStyle about that).
> 

Yes, it's so you can add a line without affecting the line before it, 
making a one-line patch into a two-line patch that's more likely to 
conflict.

	-hpa
