Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbXF0F0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbXF0F0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXF0F0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:26:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:42073 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbXF0F0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=do+D2bxTn9v/3uyhiKH/QnVWckCwvBC0qz1k1EPwTIzc7wWS0xxrc7XM8wZJpmEtWuDVmwX4i6v4J2XONmdFae3D0g6KhRfqPR9cTVtVunQH9a63T9gVfuW6e8/G1h0lTT6mKlbflhMmaIznWDOa+900uwpggzGg5SDA3sBS86M=
Message-ID: <fc94aae90706262226p417ed77ex97dd20f9bec46e25@mail.gmail.com>
Date: Wed, 27 Jun 2007 06:26:42 +0100
From: "Michael Lothian" <mike@fireburn.co.uk>
To: "Marc Perkel" <mperkel@yahoo.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <815294.60672.qm@web52504.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <815294.60672.qm@web52504.mail.re2.yahoo.com>
X-Google-Sender-Auth: 1eb8fba875f125dc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK where to start?

Firstly this is really the wrong list your writing to. Chances are
you'll be wanting to ask your question at
http://www.nvnews.net/vbulletin/forumdisplay.php?s=&forumid=14 if your
using the Nvidia Blob otherwise if your using the 2D only NV driver
then you should really aim your question at the Xorg guys and gals

Secondly how exactly did you tell it differently?

Chances are your /etc/conf.d/xorg.conf is wrong if you were using the
latest X server with the latest binary blob (nvidia driver) chances
are it would detect the highest resolution and set it for you. The
program nvidia-xconfig should fix the file for you.

Oh and thirdly do you really think it just works on windows is a good
incentive to get people to help you? Yes it should work out the box
but unfortunately the world of Linux 3D drivers is mostly dominated
with company's that prefers keeping their drivers in a black box and
hopefully in the not too distant future the neuveau project might
remedy this.

Any way I hope this e-mail both helps with your problems and adds to
your understanding of how things work. The kernel mailing list is for
kernel issues (which include rivafb and nvidiafb but not nv and nvidia
3d issues) so if you ever plug in a hard drive and it's not working at
full speed or something along those lines that's when you should call.

Cheers

Mike

On 27/06/07, Marc Perkel <mperkel@yahoo.com> wrote:
> Trying to get my Asus M2NPV-VM motherboard and my
> Samsung SyncMaster 215tw Digital to work in 1680x1050
> mode but 1280x1024 is the most I can get. Chip Set is
> GeForce 6150.
>
> Looking in Xorg.0.log it ssems to think that the panel
> size is 1280x1024 in spite of my setting telling it
> differently.
>
> Sorry if this is off topic but I thought that the
> smart people would be here. In Windows I just plug it
> in and it works. So I figure Linux should work too. :)
