Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZHAScn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZHAScn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 14:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZHAScn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 14:32:43 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:64495 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZHAScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 14:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TnlZWTEI9qPEy/vY77qoACO0C+IaNOxZpGdWBEwJfsBnd2ZZbW2YFwJ8tpFEc03j+N
         4Mj0TgtHG4qYzyd9NmSPYMh2v+rRg2yA9KYpKwRIfbiAYMc/PKgKOv2xYpE3HW5VQ+Rc
         9R/ZmLkv+e1dSXmCjdte3JLhKvl2yO5i5g+mc=
Message-ID: <4A748A48.8020702@gmail.com>
Date: Sat, 01 Aug 2009 12:32:40 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jack Byer <ojbyer@usa.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Extremely slow IO with a PCMCIA CompactFlash adapter
References: <h51hro$p6j$1@ger.gmane.org>
In-Reply-To: <h51hro$p6j$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2009 08:02 AM, Jack Byer wrote:
> I have an old digital camera that stores its pictures on a 340 MB IBM
> microdrive. I am trying to transfer to pictures from the camera to my
> computer but can not find the special non-standard USB cable. The
> camera did come with a CompactFlash to PCMCIA adapter, so tried
> connecting it to my laptop. I was able to install the correct modules
> and mount the drive, but accessing it is very slow (5.0 kBps read /
> 3.8 kBps write). Is this expected behavior? Is there any setup I am
> missing that would make this faster?
>
> Kernel version is 2.6.30.3
>
> pccardctl ls:
>
> Socket 0 Bridge:        [yenta_cardbus]         (bus ID: 0000:00:0a.0)
> Socket 0 Device 0:      [pata_pcmcia]           (bus ID: 0.0)
>
> pccardctl info:
>
> PRODID_1="IBM"
> PRODID_2="microdrive"
> PRODID_3=""
> PRODID_4=""
> MANFID=00a4,0000
> FUNCID=4
>
> time output to write a 1 MB file to the drive:
>
> real    4m29.476s
> user    0m0.000s
> sys     0m0.000s
>
> time output to read a 1 MB file from the drive:
>
> real    3m25.600s
> user    0m0.000s
> sys     0m0.000s
>
>
Can you post the dmesg output from detecting the device?
