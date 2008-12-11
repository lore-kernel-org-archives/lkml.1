Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYLKUko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYLKUko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYLKUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:40:26 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:40176 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbYLKUkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=f+J6uNVYh6IoOxpqt8BeQcs4PG1aI5AjJJLMrpGMGvDlMvXC8mNA98oWqRi8heZVfM
         Gk3JPmhxPiVkJywUeeSLeEOJWe4bbp2Py7IkXw/BY8vkUTVMnS7KrNpLNaE4IaypQre1
         Pxgm/cQOKaGn7wnRE7DAhxu7piKaJ1URkVU0I=
Message-ID: <4941793D.1000707@gmail.com>
Date: Thu, 11 Dec 2008 21:34:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       a_romanescu@yahoo.co.uk, tj@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 v2] ATA: piix, fix pointer deref on suspend
References: <493E0689.6020302@garzik.org>	<1228855948-22886-1-git-send-email-jirislaby@gmail.com>	<1228855948-22886-2-git-send-email-jirislaby@gmail.com> <20081211122712.aee1f039.akpm@linux-foundation.org>
In-Reply-To: <20081211122712.aee1f039.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue,  9 Dec 2008 21:52:28 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Commit
>> ata_piix: add borked Tecra M4 to broken suspend list
>> introduced DMI variables checking, but they can be null, so that
>> we possibly dereference null.
>>
>> Check if they are null and avoid checks in that case.
>>
>> Solves:
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff8043da97>] piix_pci_device_suspend+0x117/0x230
> 
> This already got fixed, the nasty way.
> 
> I queued "DMI: add dmi_match".  We can later switch the piix nastyfix
> over to the nicefix as a cleanup.

Oooops, I didn't Cced you to the last version, sorry for that.
