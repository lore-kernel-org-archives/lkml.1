Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZF2AVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZF2AVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbZF2ARv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:17:51 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:46452 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbZF2ARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=a+0Ka7pJKWUcSVXMNg2y5GCh3o3Dr0BaNnYI56+YfY+UVBwAW/7na75ia++isjhbxM
         8+xXPjv7zZLu4hLImM4HTvQPqx1XDAaEx+rRN8aPHQBQQKHB7DKo4BWW1gHBTPwlGGCz
         Kp0WgREUHggSZHVqhUmfVKFvNFnufQWWs6iyg=
Message-ID: <4A480859.5010206@gmail.com>
Date: Sun, 28 Jun 2009 18:18:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Christof Warlich <christof@warlich.name>
CC: linux-kernel@vger.kernel.org
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name>
In-Reply-To: <4A4771FD.1020207@warlich.name>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 07:37 AM, Christof Warlich wrote:
> Hi,
>
> when I call "s2ram -f -p" from vt1 on my HP TC1100, the system suspends
> fine, and
> when resuming, it even comes back showing the command prompt, but only
> after
> an avalanche of error messages like:
>
> [ 1598.962543] EXT3-fs error (device sda3): ext3_find_entry:
> reading directory #1025639 offset 0
>
> After that, any access to the harddisk (e.g. calling commands like ls)
> results
> in similar EXT3-fs error messages.
>
> On the other hand, suspend to ram works fine when I install on a USB
> stick, so the
> problem seems to be related to the harddisk subsystem. Furthermore, the
> hardware
> itself seems to be fine, as s2ram works with Windows XP.
>
> I tested with a vanilla 2.6.30 kernel.
>
> Please let me know if any further debugging information is required.

Are there any errors from libata, etc. showing up before all of the 
filesystem errors?
