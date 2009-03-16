Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZCPQCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZCPQCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZCPQBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:01:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:61072 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZCPQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TsPrdsvH+pym9R31KZz+z43L/M02j9gEcK2XnMsMjmZAyWWaMtQK0wssRTDP/mDiu6
         t7ihx6h4vcoHluF3ISZfFP/WxLY/Qe8Sgbs7cgwzDfU3pfKgxcSH20sw2Rpd1sP/iccB
         mdHZ2HxQQ+LoMb5uFLeNZNY0XqQbD3y1qxSeE=
Message-ID: <49BE77E7.5030107@gmail.com>
Date: Mon, 16 Mar 2009 17:01:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] drivers/char/mxser.c: Fix reference counting
References: <20090316154817.GX7301@fi.muni.cz>
In-Reply-To: <20090316154817.GX7301@fi.muni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 16:48, Jan Kasprzak wrote:
> In drivers/char/mxser.c:mxser_check_modem_status() there is a call
> to tty_port_tty_get without a corresponding tty_put() call. This causes
> the device to return -EIO on the second open(2) call.

I was faster :P:
http://lkml.org/lkml/2009/3/16/159
