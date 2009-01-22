Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZAVNMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZAVNMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZAVNMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:12:12 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:19667 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZAVNMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:12:10 -0500
Message-ID: <497870A3.4070200@turknet.net.tr>
Date: Thu, 22 Jan 2009 15:12:03 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
References: <49771D65.3090205@turknet.net.tr> <20090121152818.GA3438@x200.localdomain>
In-Reply-To: <20090121152818.GA3438@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2009 13:12:03.0560 (UTC) FILETIME=[0493C680:01C97C93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> # CONFIG_FIRMWARE_IN_KERNEL is not set
>   
>
> Try setting this option to =y.
>   

Thanks for the reply. I tried with "CONFIG_FIRMWARE_IN_KERNEL=y" as you 
suggested. But, still I get the same warning.
It looks like ubuntu's make-kpkg utility or kernel compile process do 
not care about "CONFIG_FIRMWARE_IN_KERNEL=y" and still building modules 
without firmware built-in.



