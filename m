Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZBZJSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZBZJSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZBZJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:18:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:29796 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZBZJSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KZubYNkvjBmqfep6gfAA62IKPtj6nWJagMWZ8exYJsdhgWCOk3YulPpWBv1zCsK6rr
         JU7eVSrYW5uVA8DbeDAtYFIUbsryTcPGQ7sDPBEmVqas5hnJ7FVctf/A3pa7KewIptiW
         bAkVHXa339bFo1eqGhZmaXZYSybpwp7jfm5Tw=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com>
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com>
Date: Thu, 26 Feb 2009 10:18:29 +0100
Message-ID: <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com>
Subject: Re: Crash in 2.6.28.7 - ext4 related
From: Fabio Comolli <fabio.comolli@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I see that my message didn't reach neither linux-kernel nor
linux-fsdevel, maybe because of the image size (484K).

If anyone is interested in details, please let me know.

Regards,
Fabio



On Wed, Feb 25, 2009 at 9:03 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi all.
> I experience hard crashes with latest stable kernel (but also in every
> 2.6.28.y release). This time I was trying to remove a large directory
> (a kernel tree) in a clean (fsck -f from a previous crash) ext4
> partition.
>
> The partition is an ext3 converted one, with extents enabled. It's
> about 20gb in size.
>
> When the crash happened the sistem was just booted in single user;
> fsck -f; mount; rm -rf <dir>; bang. Please look at the attached
> picture.
>
> The kernel is vanilla 2.6.28.7 + opensuse bootsplash patch.
>
> Please let me know if you need more details. Unfortunately for me it
> seems to be pretty easily reproduceable. By the way, some of the
> previous crashes did not involve file removals.
>
> Regards,
> Fabio
>
