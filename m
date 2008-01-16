Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYAPBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYAPBHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYAPBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:07:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:24321 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYAPBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z2Tc5HI5dxe3jWLKfyEiZ8W4STvsh2k0AuQp5rMIO5t+b5TTgK9qAlNNqBGh42RFptRS7RZ4FRmT0hN+AOWcJofWGagZKoP4e7C9q/sIqg1CK3w0BVe36Q2vOgRXnqA2LM3ofC0oWnlnJrLecGfLuOrnoHqx2tATK/TvQqiXhaM=
Message-ID: <478D58B8.1000705@gmail.com>
Date: Wed, 16 Jan 2008 10:07:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
References: <1200445210549-git-send-email-htejun@gmail.com>
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> This patchset implements printk_header() and mprintk - merging printk
> - to make printing multiline messages and assembling message
> piece-by-piece easier.
> 
> In a nutshell, printk_header() lets you do the following atomically
> (against other messages).
> 
>  code:
>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");

That should have been printk_header instead of printk.  Sorry.

-- 
tejun
