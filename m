Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbYDOHka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbYDOHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYDOHkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:40:18 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:59107 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYDOHkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ayuu5VsImkFcOf2qZ7XfGnxXo375dLIWIejTmP18ql+74eh1KtSrfwGPyUCsinPyaJLo7bjbUbdSX95D1/CspdHtmT0p7WE6DkFRosl7Ja2h3ZyXA65freDrJsf0c1lEAuhEDsoJq9AD02SSKl4wCh0MzlU6Kf+kzm/mWe0j64c=
Message-ID: <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
Date: Tue, 15 Apr 2008 09:40:15 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <480354C9.1050600@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <480354C9.1050600@bfh.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seewer,

On Mon, Apr 14, 2008 at 2:57 PM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>
>  As you've problably seen from the other answers, disk geometry is (except
> for a few older devices) unneeded inside the Linux kernel.

Yes but I'm doing userspace stuff and that's the reason I was asking for the
sysfs thing.

> I'd say thats the
> reason why there's no sysfs export and I'd further guess disk geometry is an
> artifact most would like to get rid of (or pushed into userspace).
>

Well, I looked at sfdisk(8) and parted(8) source code and they all need the
geometry description. If I understood correctly the reason why is that it
'prefers' to align partition sizes/starts on a cylinder boundary because some
bootloaders probably use CHS addressing, but I'm really not sure.

>  Anyway, if you really need it, try the patch below. Should apply cleanly to
> version 2.6.23.1 and gives you a geometry/ directory for each block device
> providing the getgeo function. It adds a setgeo counterpart for some
> subsystems as well, allowing 'echo something > ...' so please be careful.
>

Thanks but I probably won't use it. Using sfdisk, for example, is a
more portable
way to get the geometry from a script.

-- 
Francis
