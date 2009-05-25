Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZEYXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZEYXqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZEYXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:46:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41193 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZEYXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UWR8GBUBWAMhuS/SFtH8uWa8Z7p3znCHQtOXCCITqP62GNio0ztE6k8DyRBw3RLCCh
         hY3aM6fipDHZ23a8BwBz3yswr4a41V3tANr2XL++RGC/ZtkWbR6A2HHIE8S+T8rfnvA/
         d2LfoGiKvcGDPT50awXnct5SUrZ7rWU4FNpvU=
Message-ID: <4A1B2DD6.3050405@gmail.com>
Date: Mon, 25 May 2009 17:46:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: chmod fails though it pretends to succeed
References: <20090525164457.278f0ec0.Christoph.Pleger@cs.tu-dortmund.de>
In-Reply-To: <20090525164457.278f0ec0.Christoph.Pleger@cs.tu-dortmund.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pleger wrote:
> Hello,
> 
> I have a strange problem here with a C program that calls chmod.
> 
> The C program is a PAM module called pam-devperm. The purpose of this
> module is to set appropriate device ownerships and permissions when a
> user logs in. But the module does not work as expected on my Ubuntu
> 9.04 system. When a user logs in the first time after system boot, only
> the device ownerships are changed, the permissions are not. When the
> user logs out and in again, permissions are changed, too.
> 
> I added some lines of code to the the source of of pam-devperm so that
> it produces more debug output when changing the properties of /dev/dsp.
> The debug output showed me that chmod has been called to set the
> permissions of /dev/dsp to 0600 and that chmod returned 0, which means
> success. In spite of that, device permissions remain at 660.
> 
> Now I have two questions:
> 
> 1. What can be the reason for chmod to return a value of 0 though
> device permissions have not been changed?
> 
> 2. What can be the reason why this chmod fails on the first login of a
> user, but succeeds on further logins?

Are you sure that some other process is not changing the device 
permissions also?

> 
> Regards
>   Christoph  

