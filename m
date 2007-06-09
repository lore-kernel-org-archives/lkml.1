Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXFIR1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXFIR1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXFIR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:27:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:10655 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbXFIR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=a45K2yha9LqAE74rzXVP/oyAsrjIwQmd+qSyrNDCW0F8dYfPuitldCjBOymz2aIiul7H3YQaKHQp56u91uVNsjLz9ujnh+8LcUzdW7GyY5XmsNnVkEdwhE+hTTd9dbSAV3hORtCnSlaMsdQNvf9ya9RPIodEoa3ZhSWONjeR7+M=
Message-ID: <3ae72650706091027k649e5194l9af84cfadbbadad9@mail.gmail.com>
Date: Sat, 9 Jun 2007 19:27:15 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Rules on how to use sysfs in userspace programs
Cc: "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>, daniel.ritz@gmx.ch,
       linux@brodo.de
In-Reply-To: <466A9DDD.2040107@ums.usu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608203637.GA9259@kroah.com> <466A9DDD.2040107@ums.usu.ru>
X-Google-Sender-Auth: 5c9b0e2a0e8254d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Alexander E. Patrakov <patrakov@ums.usu.ru> wrote:
> Greg KH wrote:
> > - Do not use libsysfs
> >   It makes assumptions about sysfs which are not true. Its API does not
> >   offer any abstraction, it exposes all the kernel driver-core
> >   implementation details in its own API. Therefore it is not better than
> >   reading directories and opening the files yourself.
> >   Also, it is not actively maintained, in the sense of reflecting the
> >   current kernel-development. The goal of providing a stable interface
> >   to sysfs has failed, it causes more problems, than it solves. It
> >   violates many of the rules in this document.
>
> The problem is that even on ftp.kernel.org there are packages like
> pcmciautils that still link to libsysfs and contain things like #define
> PATH_TO_SOCKET "/sys/class/pcmcia_socket/". Are they expected to be fixed?

It will continue to work, because we keep the symlinks it expects, but
libsysfs is so broken in its interface, that nothing should use it,
especially nothing should start using it today.

Thanks,
Kay
