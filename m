Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXLPXwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXLPXwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbXLPXwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:52:39 -0500
Received: from hs-out-0708.google.com ([64.233.178.241]:59018 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751762AbXLPXwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FGZ8d2yQ5kz4PBOz6+HgWxzOINrKzQ8hq3jPXyPRGNo9a+z2Vem5m+WV1FUsXLzFNAnSAgY6WxSWjqU6+aULQBO5AHDj5re2eFb302YbBR9kxtN8fIfNS/xtX7UOIGSZ28P2Q4Vv3BVV1EmRmRDVQ1v1+P5PLn9X0iN69FG1XBE=
Message-ID: <ee3dc96c0712161552x133496ebq3a04150385b9a3b6@mail.gmail.com>
Date: Sun, 16 Dec 2007 20:52:36 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Luciano Rocha" <luciano@eurotux.com>,
       "Rafael Sisto" <rafael.sisto@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: shared memory
In-Reply-To: <20071216223014.GA13628@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com>
	 <20071216195715.GA10287@bit.office.eurotux.com>
	 <ee3dc96c0712161201y34a3e3e0t601ab4fa73d002c@mail.gmail.com>
	 <20071216223014.GA13628@bit.office.eurotux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks a lot!!


On Dec 16, 2007 7:30 PM, Luciano Rocha <luciano@eurotux.com> wrote:
> On Sun, Dec 16, 2007 at 05:01:17PM -0300, Rafael Sisto wrote:
> > Thank you for the quick answer, but It's a college project, and I must
> > share user level memory. I also must build my own system calls...
> > But I can look what is already done and make something similar. Do you
> > think shmget would do? Does it share user level memory?
>
> Yes. They both do, but the Posix one is based on a ramfs or tmpfs on
> /dev/shm and shared mmaps. I think analyzing the SysV version will be
> better for your needs.
>
> shmget: create the memory region
> shmat: attach the memory region to this process.
>
> --
>
> Luciano Rocha <luciano@eurotux.com>
> Eurotux Informática, S.A. <http://www.eurotux.com/>
>
