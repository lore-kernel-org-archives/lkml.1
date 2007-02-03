Return-Path: <linux-kernel-owner+w=401wt.eu-S1750942AbXBCXoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbXBCXoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXBCXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:44:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:60120 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbXBCXoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UB6Qcij+9cVCW0tkOStjFPlQ0ApreQZ67KzDe9gn8MvH1eNeS9uo9YZ9KUv5i3W1wgnd+ozoQg8rcheac1osYtRjxcNtiaw6QZwix1ywf8Ddl0nb+de0sR6YmRIbb//kvLtB0KZxvFHR5lDvVgpVsiZa05EjzXXb9rihhH3a/es=
Message-ID: <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
Date: Sun, 4 Feb 2007 00:44:08 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Stephen.Clark@seclark.us
Subject: Re: hdparm for lib_pata
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <45C5178A.1000501@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
	 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Stephen Clark <Stephen.Clark@seclark.us> wrote:
> Robert Hancock wrote:

> But why are we taking away the users capability to control his/her own
> hardware. Sounds like windows.

I wouldn't go as far as making that comparsion, most of all cause it's
totaly invalid, with all respect.

In my opinion the new pata drivers are work in progress, they only
appear in the latest kernel and snapshots so please, let's allow the
drivers to evolve, I am no kernel hacker or coder, nor does my
interest lay here at the moment to be honest, I am a system
administrator working with Unix and Linux and am interested in helping
out where I can. By using the new pata drivers in favor of the old IDE
drivers I took a risk, well calculated and with the very thought of
encountering these kind of problems and reporting them to make things
better.

However, I do have to agree with the point that if the drivers/kernel,
for whatever reason they might have, to switch to a lower UDMA mode,
and when none is left, even to PIO mode, I should have at least the
chance to switch back to a higher level of datatransfer speed.

How it looks now is that the kernel and its drivers treat the devices
as ATA devices with their features, but the userland programs like
hdparm and sdparm and blkutil see the devices as SCSI/SATA devices,
and dont allow the ioctl commands which are valid for ATA drives.

Just my two euros/canadian dollars/croatian kunas in the pocket :)

Patrick
