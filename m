Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYFBK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYFBK2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYFBK2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:28:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:61841 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYFBK2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cLtyM1TZqQw7DDo6MMPUT6FS3OXffB2iqgGuM7hrqnd0s9JSmJZTtclcDq5m+6G8xyLI/RmSE5C75yFwTEKlY4ibJzo/ie1kfYUfsNAq7uivJd3nvp1z8uB7y+Z04le+T/Pmqo0IUzjrUj/0gQJp6/J4Me7Qmaam+7037yZDFwk=
Message-ID: <3ae72650806020328s7afa7eccr758bf613b61afc5@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:28:01 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Subject: Re: floppy question of the hour
Cc: "Gene Heskett" <gene.heskett@gmail.com>, "Phillip Susi" <psusi@cfl.rr.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <alpine.LNX.1.10.0806012053440.4055@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
	 <200805240852.58268.gene.heskett@gmail.com>
	 <483C81DE.8060002@cfl.rr.com>
	 <200805271826.18320.gene.heskett@gmail.com>
	 <alpine.LNX.1.10.0806012053440.4055@fbirervta.pbzchgretzou.qr>
X-Google-Sender-Auth: 6030ab0261416986
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 9:00 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2008-05-28 00:26, Gene Heskett wrote:
>>On Tuesday 27 May 2008, Phillip Susi wrote:
>>>Gene Heskett wrote:
>>
>>Also, does anyone know how long after a floppy is inserted before it is
>>recognized?  From observation today, it appears to be something in the 5 minute
>>territory before a getfdprm returns data instead of "/dev/fd0: no such device".
>
> I have a SONY USB floppy drive which used to get read within 2s
> after inserting a new floppy. Which means it somehow signalled
> the host, probably through an USB command.
>
> Just as I tried again now (with 2.6.23.17), this does not happen
> anymore so I suspect udev or the kernel changed in some way.

There is no  USB command for media change notifications. We
periodically poll USB floppies with HAL. We can do this, because
unlike legacy floppies, USB floppies seems not to spin up the drive
when polled.

Kay
