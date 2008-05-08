Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbYEHHJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbYEHHJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYEHHJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:09:19 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:40652 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760840AbYEHHJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=lW7VlL4/zpzSyxkQt0SyhemtlFc9MqcqXUpR/FGIsm45cEryDoxKy56F5QtgLWz0y1wRABgP6n3c+F7VV+MWFhmDdodIZ2lNIXfCOSdSG0oigkcIyusgXTqO0umjVRe71oq7oDAq6MWFd8OBpyhSqYuY18i810nM6HmRxM2Z6RY=
Message-ID: <4822A706.1040700@gmail.com>
Date: Thu, 08 May 2008 08:08:54 +0100
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25 pci=noacpi
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com> <4813B5AB.4060308@keyaccess.nl> <200804281507.38309.bjorn.helgaas@hp.com> <4816C605.4000601@gmail.com> <481E0D2D.1030608@keyaccess.nl>
In-Reply-To: <481E0D2D.1030608@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 29-04-08 08:53, Richard wrote:
>
>> Using an AMD Sempron notebook (HP Compaq 6715b) single processor 
>> machine,  It shuts down during bootup when ACPI is fully enabled.  I 
>> added pci=noacpi to the cmdline and it finally boots, but its 
>> extremely slow...  (kdm times out with error saying it took too long 
>> to load and disables graphical)
>
> Does booting with io_delay=0xed on the kernel command line fix it? If 
> so, we need the output of
>
> # dmidecode -s baseboard-manufacturer
>
> and
>
> # dmidecode -s baseboard-product-name
>
> Rene.
>

Tried the io_delay=0xed.... doesnt fix it. machine shuts down :-P

Richard

