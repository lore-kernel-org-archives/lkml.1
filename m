Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbYFRJUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbYFRJUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYFRJU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:20:26 -0400
Received: from mail.renesas.com ([202.234.163.13]:41613 "EHLO
	mail05.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbYFRJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:20:24 -0400
X-AuditID: ac140388-0000000700006b18-74-4858cdf039f8
Date: Wed, 18 Jun 2008 17:57:21 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: sh/boards/se/770x/io.c: suspicious code
In-reply-to: <20080615221606.GA1407@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <4858CDF1.3070804@renesas.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
References: <20080615221606.GA1407@cs181133002.pp.htv.fi>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Adrian.

Adrian Bunk wrote:
> sh_pcic_io_start and sh_pcic_io_stop are used as lower and upper limits 
> for ports but never set to any non-zero value.

This code is used from linux-2.4 very old.
Mrshpc_ss.c(pcmcia socket driver) used sh_pcic_io_start in linux-2.4.
This driver doesn't exist now. The place where you are pointing it out
might already be unnecessary. I will send the patch to clean it.

Best regards,
  Nobuhiro





