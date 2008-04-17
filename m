Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbYDQOJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbYDQOJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYDQOJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:09:16 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:17824 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYDQOJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i0MYsgD3qg7rOYUBAyViFjG5D8hFv+ld5E9j5nUb4ozeWu4jSQTX2sMnefEw/rhA0rqhjmu5UoeDTunvWdITw9Lwx73LQcpND8Up2BeCgPwkuR9iql2WD2lc8wisp3mK2j6NCrKkMHs657b4ffam5qCW4EBvxJPbjc0E4amfX04=
Message-ID: <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
Date: Thu, 17 Apr 2008 16:09:01 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4805AF93.90209@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <480354C9.1050600@bfh.ch>
	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
	 <4805AF93.90209@bfh.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Seewer,

On Wed, Apr 16, 2008 at 9:49 AM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>
>  Correct. Though be really careful which geometry you are requesting:
>
>  root@local:/# sfdisk -g /dev/sda
>  /dev/sda: 7296 cylinders, 255 heads, 63 sectors/track
>  root@local:/# sfdisk -G /dev/sda
>  /dev/sda: 116280 cylinders, 16 heads, 63 sectors/track
>
>  The first one is the kernels idea of a disks geometry which is probably as
> often correct as it's just plain wrong,

Sorry but I don't understand, what do you mean ?

>  versus the second one which tries to
> guess a disks geometry by looking at the current partition table. Which
> might be just as wrong since its only necessary for bios and/or bootloader.

But what happens if you want to guess the geometry of a disk with no
partition table ? You need to trust the kernel guess but from what I understood
it's just wrong.

thanks
-- 
Francis
