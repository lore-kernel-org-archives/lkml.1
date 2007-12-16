Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbXLPUB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbXLPUB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 15:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXLPUBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 15:01:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:33748 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXLPUBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 15:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SYXkebAHD43o9edemQFy+C2d3bldcP7U7PFph/xuExmsGsMbJVdzHbkTT5PunGWEKSzYpCtnKVTEVCGkrmRymK+MAcyzW2o7AO4yOvt6SBJd8s3YV8S5Izl/s/TZ0qjl+jY2BKiz99zhzSS9eTUg3hFF349f4vXQtWc08jm2j54=
Message-ID: <ee3dc96c0712161201y34a3e3e0t601ab4fa73d002c@mail.gmail.com>
Date: Sun, 16 Dec 2007 17:01:17 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Luciano Rocha" <luciano@eurotux.com>,
       "Rafael Sisto" <rafael.sisto@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: shared memory
In-Reply-To: <20071216195715.GA10287@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com>
	 <20071216195715.GA10287@bit.office.eurotux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the quick answer, but It's a college project, and I must
share user level memory. I also must build my own system calls...
But I can look what is already done and make something similar. Do you
think shmget would do? Does it share user level memory?

greetings!
Rafael Sisto

On Dec 16, 2007 4:57 PM, Luciano Rocha <luciano@eurotux.com> wrote:
> On Sun, Dec 16, 2007 at 04:51:39PM -0300, Rafael Sisto wrote:
> > Hi, Im working on a project working on linux kernel 2.6.17
> > I have to share memory on user level... I have to build something like
> > a server process that "exports" a portion of his virtual memory, and
> > other client process may ask the kernel for that memory and use it (as
> > its own).
> > I managed to build a structure on the kernel.
>
> Why? Aren't SysV IPC or Posix IPC enough?
>
> See "man shm_open", for the new Posix version, and "man shmget" for the
> old SysV IPC version.
>
> --
> Luciano Rocha <luciano@eurotux.com>
> Eurotux Informática, S.A. <http://www.eurotux.com/>
>
