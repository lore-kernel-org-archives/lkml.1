Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYJVSLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYJVSLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYJVSKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:10:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:2881 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYJVSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f7N2QR6JYbkrv+jxip7ZPZilIVFmuh8b/D62ghNuan2SY9mcmoIA9iTghbnnZtfJRd
         PLU0mIEB1HUHm1+KoJd/JXSqcC7+9XrfrNcVoZyLY6RoBqaNTem+hye5183XwR61Ku9z
         OqFRqsr6sJvSBsO017c/g9RGdcB6t/3LFOcVw=
Message-ID: <d9def9db0810221110g6f104b17g36a74704d43c5693@mail.gmail.com>
Date: Wed, 22 Oct 2008 20:10:49 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alex Riesen" <raa.lkml@gmail.com>
Subject: Re: [PATCH] em28xx patches against the latest git tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
In-Reply-To: <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com>
	 <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
	 <81b0412b0810221059w2e02b1c1ubd894b22f7991242@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 7:59 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> 2008/10/22 Markus Rechberger <mrechberger@gmail.com>:
>>> commit history is available at:
>>> http://mcentral.de/http://git.kernel.org/?p=linux/kernel/git/mrec/linux-2.6.git;a=commit;h=f1be9ae8f8489a6598417a194e0899ac00c7530ehg/~mrec/em28xx-new
>>>
>>
>> this should be:
>> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
>>
>
> There is already an Empia EM28XX driver in the official tree. If your driver
> is based on it, could you point at the first commit in *your* tree at
> mcentral.de which
> corresponds to that driver? (if you do, your history can be moved into
> central Git
> repo completely, every commit of it)
>

The development has been split off for 3 years from the original
repository. The internal driver differs alot.
The full history of that driver can be seen when looking at:
http://mcentral.de/hg/~mrec/v4l-dvb-experimental

that code back then got split out of the linuxtv repository and moved to:
http://mcentral.de/hg/~mrec/em28xx-new

The driver has a long and rather bad history, which I'd like to avoid
by using the different directory.
Some patches got ported from my repository into the kernel although
most devices don't work at all with the current inkernel driver (eg.
em2888, flash based, isdb-t, cx25843, some saa7114.. based devices).

here's some development status history starting in 2006.
http://mcentral.de/wiki/index.php5/Em2880/Status
moved over to a mailinglist and support people from 2007 - currently
http://mcentral.de/pipermail/em28xx/

there's almost nothing of that work merged yet, and there are tonns of
howtos out there which are based on all that right now.

regards,
Markus
