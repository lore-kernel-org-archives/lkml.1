Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZDMGDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZDMGDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZDMGCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:02:40 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:53592 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZDMGCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:02:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=lkSOLjJrtIyOAdgBTTcqakXSfquwZI7mBAVIZvoMu4zmco+c3Zx0BK0MVhOmHMLn89
         eCZX7MuRLeMJxaT5FGLyrzZ9yC1u5GncLOJ8mV41ZKLnQAfYEyGelwC/mNhwYcGMtO26
         8IlzXzHkDpmVexJzQC0uK/hvVGL3Eo0yQR65s=
Message-ID: <49E2D57A.8000906@gmail.com>
Date: Mon, 13 Apr 2009 00:02:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: stonee@Safe-mail.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Unknown initrd commands
References: <N1N-uRW2YWBw5x@Safe-mail.net>
In-Reply-To: <N1N-uRW2YWBw5x@Safe-mail.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stonee@Safe-mail.net wrote:
> I have been digging around a few times online, and have not been able to find where some commands invoked from the Fedora init script are located.
> 
> The contents of the script are as follows along with some notes that I've added:
> 

...

> mkblkdevs
>    # ? 
> stabilized --hash --interval 250 /proc/scsi/scsi
>    # ?
> resume /dev/sda2
>    # ?
> 
> echo Creating root device.
> mkrootdev -t ext3 -o defaults,ro /dev/sda1
> echo Mounting root filesystem.
> mount /sysroot
> echo Setting up other filesystems.
> 
> setuproot
>    # ?
> 
> loadpolicy
>    # ?
> Where are these commands documented? Also, do initrd/nash have a home page? 
> 
> Thanks! 
> 
> By the way, please include my safemail e-mail in responses as I am not subscribed to the list.

I believe these are nash built-ins. There's a man page, but it doesn't 
seem to list these commands, presumably it's out of date. Likely the 
only good documentation for them is the nash source code..
