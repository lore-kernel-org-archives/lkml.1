Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYAHI2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYAHI2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYAHI2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:28:13 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:59056 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYAHI2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YDqH/T7ka8hMDrkO/YQB+4vH34JFHCZze9aXzo6gvo3rZarjgXwt7zbDr5EL2STlqQ8VR+61IqKhx/zJKOjvJTLmOYqMqU17kv+Hy7CsfPWlNPXOhDaUAMCT8h8tVKIjKmeXeaLhj8bTsX0/Oi6XorxJlMAb5lprq0LP1g0bOEc=
Message-ID: <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
Date: Tue, 8 Jan 2008 16:28:10 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Michal Simek" <simekm2@fel.cvut.cz>
Subject: Re: New linux arch
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu
In-Reply-To: <47820D24.3060800@fel.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47820D24.3060800@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 7, 2008 7:29 PM, Michal Simek <simekm2@fel.cvut.cz> wrote:
> Hi all,
>
> I redesigned all files for microblaze cpu (xilinx fpga).
> All code is FDT compatible.
>
> I would like to ask you what is the best way to push these changes to
> kernel.org.
>

Welcome to the home of kernel.
I remember Blackfin maybe is the most recently new arch accept by
kernel mainline. So maybe some information can be shared with you
guys.


> I would like to know step by step how to do.
>

1. Push patches to LKML when merge window open (2 weeks after a stable
kernel version release, for example 2 weeks after 2.6.24 released)

2. Patches will be reviewed by kernel gurus and please update your
patches according to their comments. (It will take some time to get
ack from them -:)) ).

3. Reviewed patches will be accept to -mm tree by Andrew. (And please
do development and updates based on -mm tree)

4. After one or more development cycle, the patches will be sent to
Linus to merge into mainline kernel at another merge window.

5. Use GIT to maintain the Microblaze subsystem development and you
can apply an account on kernel.org. Then setup a public GIT tree for
Linus pull and development.

> I have some question about.
>
> I have changes in my internal git repository. I don't have public git
> repository.
> Is it possible to create git repository in git.kernel.org for Microblaze
> cpu?
>

Currently no need public git tree, after it is merged into mainline,
you can apply one for maintaining and development.

> What are maintainers responsibilities? Do you have any page about?
> I am  U-BOOT maintainer at denx.de and I hope that the responsibilities
> will be similar.
>

IMO, maintainer of one subsystem should review all the patches related
your subsystem,
test the patches at real hardware, fix bugs and send them to upstream
mainline at the right time.

> How many maintainers are acceptable? (one or more)
>

It depends on your internal development style. There is a team in
Analog Devices for Blackfin Linux development.
But I am responsible for kernel maintaining currently.

> I checked whole code with checkpatch.pl script to avoid code violations.
> I hope I resolve the most of coding style problems.
>

Yes, passing checkpatch.pl is required by LKML.

> I see the right way to push all changes to public git repository and
> then send patches in small logical group to LKML with CC to people from
> microblaze community.
>

No, please send out all your patches to LKML and CC to Microblaze world.
People from LKML will review your patches.

> And then wait for comments from you, solve problems, update git
> repository and send changes again.
>
No. update your patches and send the patches to LKML again.
GIT pull is only validated after your patches are in mainline.

Thanks
Regards,
-Bryan Wu
