Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbYA2Que@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbYA2Que (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760441AbYA2QuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:50:22 -0500
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:44652
	"EHLO QMTA09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758578AbYA2QuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:50:20 -0500
X-Authority-Analysis: v=1.0 c=1 a=LhEZLq1m22fBr3wI_CwA:9 a=GPR280To7Hsl1fscFVK1Bq9cv2sA:4 a=vNGxQsTWjH8A:10
Message-ID: <479F5949.4090906@bobjweil.com>
Date: Tue, 29 Jan 2008 11:50:17 -0500
From: rgheck <rgheck@bobjweil.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Florian Attenberger <valdyn@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <200801281413.21347.gene.heskett@gmail.com> <20080129074127.5699afcf.valdyn@gmail.com> <200801291004.12565.gene.heskett@gmail.com> <479F507A.1030203@rtr.ca>
In-Reply-To: <479F507A.1030203@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Gene Heskett wrote:
>> ..
>> Does anyone know why my dvdwriter isn't being assigned a '/dev/sdx' 
>> number when dmesg says its found ok at ata2.00?  I've turned on an 
>> option that says something about using the bios for device access 
>> this build, but I'll be surprised if that's it. :)
> ..
>
> It should show up as /dev/scd0 or something very similar.
>
Does it appear as /dev/sr0? Try ll /dev/s* and see what you get.

Anyway, these /dev/ entries are produced by udev, not by libata.

rh

