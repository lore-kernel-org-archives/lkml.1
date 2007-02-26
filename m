Return-Path: <linux-kernel-owner+w=401wt.eu-S1030433AbXBZSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433AbXBZSqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030432AbXBZSqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:46:37 -0500
Received: from terminus.zytor.com ([192.83.249.54]:45480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030430AbXBZSqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:46:36 -0500
Message-ID: <45E32AFD.2050407@zytor.com>
Date: Mon, 26 Feb 2007 10:46:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Zach Brown <zab@zabbo.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI>	<20070226003307.6f38d2ee@lxorguk.ukuu.org.uk>	<84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com>	<45E291F7.6060508@zytor.com>	<79B7BBDC-E953-4EAE-8D32-E510DE0981FF@zabbo.net> <20070226194131.2c4e4a47@lxorguk.ukuu.org.uk>
In-Reply-To: <20070226194131.2c4e4a47@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
>> I'm not sure.  Turning, for example, the statat(dir_fd, name == NULL)  
>> error case into fstat(dir_fd) sounds like a way for apps, admittedly  
>> buggy ones, to be surprised.  Maybe libc would be exptected to catch  
>> the error before performing the shared system call?
> 
> At that point would it not be cheaper to have two system calls, the table
> cost isn't very large.

It's not just the table, though, you need two entry points, but even 
that isn't really all that big either, I guess.

	-hpa
