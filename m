Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYBNPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYBNPCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYBNPCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:02:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22813 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYBNPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ltN0oCeycrEFvwOIxkIQ1n4UAWsslJNAgXTJtx3QUIAFkGHZum1YVvwNb76gRykl4WRR5JRgthcmL2k+sSamKfEmxesFXs+9b82NbeLD0B0nAm5U6qjfQLGfUACiRosPY7LG1tEa+O6jhkVKVoRY9GZgtt54pBfBj5/Cf/66tT8=
Message-ID: <47B457F5.8010306@gmail.com>
Date: Thu, 14 Feb 2008 16:02:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Sergio Luis <sergio@larces.uece.br>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "gdth: update deprecated pci_find_device" is incorrect
References: <47B453D3.5060707@gmail.com> <47B45469.5070103@gmail.com>
In-Reply-To: <47B45469.5070103@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2008 03:47 PM, Jiri Slaby wrote:
> On 02/14/2008 03:44 PM, Jiri Slaby wrote:
>> commit
>> 99109301d103fbf0de43fc5a580a406c12a501e0
>> in jejb/scsi-rc-fixes-2.6.git is incorrect. You don't decrement pci 
[...]
> BTW if you have more than one card, you protected the driver from no 
> race, since you don't pci_dev_get of successfully grabbed cards.

(this still holds)
