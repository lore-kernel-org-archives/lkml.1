Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZASMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZASMYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZASMYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:24:06 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:38913 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700AbZASMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:24:05 -0500
Message-ID: <497470CC.6070202@arcor.de>
Date: Mon, 19 Jan 2009 13:23:40 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de> <200901141449.37246.vlobanov@speakeasy.net> <496F012C.9020004@arcor.de> <200901161617.18351.vlobanov@speakeasy.net>
In-Reply-To: <200901161617.18351.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Unfortunately this bit is not the complete solution for your problem.
>> When setting PUE then connect and disconnect events cannot be
>> detected by UDC. If you disconnect and connect again you
>> probably will notice that there will be no new enumeration as
>> expected.
> 
> Interestingly enough, when running in this configuration, unplugging and 
> replugging the cable does cause a re-enumeration. Hmmmm.
> 
> -- Vadim Lobanov
> 

Ah, I see. So PUE would be OK so far. I assume this worked as host
recognizes a disconnect/connect and performs a USB reset. USB reset
has almost the same effect as disconnect/connect on device side.

Thomas

