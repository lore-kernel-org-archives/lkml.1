Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZLVAbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZLVAbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZLVAbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:31:12 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:52091 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZLVAbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SMXqFL+Txo67sAswJZ8aMUvfqpAX0HGCbD1lYFyyZz3ResrPTIzDeOIl2I6Uoa1m8g
         PI1ZnZWTatmtEky2US52qRysWSG8V7vpzllzQ8QavJMQmcPcAnVXg8rjDPLby7WP/JVC
         qtWfZULyDzwKqkBFxDG+iv3j4c5xfI6++M8ro=
Message-ID: <4B30134C.1050609@gmail.com>
Date: Mon, 21 Dec 2009 18:31:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 05:12 AM, fengxiangjun wrote:
>
> Hi,
>
> after upgrading to 2.6.32.2,
> with the attached config,
> kernel booting always(just tried 10+ times) failed at:
>
> ata1.00: SATA link down (SStatus 0 SControl 301)
> ...
> VFS: Cannot open root device ...

There were no libata changes in 2.6.32.2 that should have affected this. 
Are you sure the .config is unchanged? Have you rechecked that 2.6.31.1 
still works?
