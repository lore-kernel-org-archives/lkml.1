Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZKKVSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZKKVSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZKKVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:18:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:19404 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbZKKVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nD3j76quJkGmdtejpDclEoNMP631+4EPmMeD0zXnlfQFyV/vgJjurBo4hT27z2Lm5A
         LNylx+Citds1bqrfItqaNxtJu5MuG2HLdEFAgraORRGNoS9zJx8rdyUugnUFIM7MdpoC
         BSoC52uT/EDXz85za83ZParHa9QUIGNuTJrGg=
Message-ID: <4AFB2A3D.6030204@gmail.com>
Date: Wed, 11 Nov 2009 15:18:53 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Michel <michel.linux@sfr.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Lacie Mobile Disk 250 GB USB 2.0 not recognized by my computer
References: <4AFB224C.7090506@sfr.fr>
In-Reply-To: <4AFB224C.7090506@sfr.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 02:45 PM, Michel wrote:
> Hi,
>
> i'm in great trouble,
>
> i bought a "Lacie Mobile Disk 250 GB USB 2.0 HI-speed", but it seems not
> recognized by my computer.
> The device seems locked when i connect it to a USB port, the diode blue
> light remains on,
> and i can hear a litttle "tick" every second near the disk, i didn't
> heard the disk turning. feels like it is blocked.
> - dmesg displays nothing before and after plug-in the device
> - the scan of the connected usb port by usbmon reports nothing at all.

If there's really no output at all then it sounds like the USB 
controller isn't even detecting the device. Maybe it's drawing more 
power than the motherboard wants to provide and can't initialize 
properly? Have you tried a different USB port?
