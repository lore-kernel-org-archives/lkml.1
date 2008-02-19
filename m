Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYBSRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYBSRWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 12:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYBSRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 12:22:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbYBSRWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 12:22:34 -0500
Message-ID: <47BB1053.60409@zytor.com>
Date: Tue, 19 Feb 2008 09:22:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rasmus Andersen <rasmus@avlebavle.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: LILO fatal error after going from 2.6.22 to 2.6.24.2
References: <20080219070201.GA7353@avlebavle.dk>
In-Reply-To: <20080219070201.GA7353@avlebavle.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Andersen wrote:
> Hello,
> 
> I have just upgraded from 2.6.22 to 2.6.24.2 and after booting into the
> new kernel and seeing that everything went right, I wanted to make the
> new kernel the default boot kernel. But running LILO I got
> 
>    Fatal: Linux experimental device 0x04x needs to be defined.
>    Check 'man lilo.conf' under 'disk=' and 'max-partitions='
> 
> (Full output from lilo -v 5 below). Apart from setting 2.6.24.2 as
> default this is the same lilo config as 2.6.22 was able to write fine.
> Can anyone tell me what I (or the kernel) am/is doing wrong?
> 

You have at least one file on a device mapper device (possibly an LVM 
module), and LILO doesn't understand it.

	-hpa
