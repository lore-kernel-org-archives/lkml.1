Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZKTIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZKTIMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZKTIMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:12:09 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45558 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKTIMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=etW4PwK/10hkbKvq1dYqVoNfJSnQZa4b52fCIHo4fHZGdFSk8smTRfNfEp/vF2lR1V
         RyySxx4nneERxLQuh4pO9woefMvjuD0Sw0HCsYlGmEdsLD87w4rcxecndzhryvs3iuzn
         HRkjw+Dktp9E/bHqvYBURMgPdvMNIybGGTlUY=
MIME-Version: 1.0
In-Reply-To: <4B06384C.2080703@gmail.com>
References: <4B06384C.2080703@gmail.com>
Date: Fri, 20 Nov 2009 16:12:14 +0800
Message-ID: <7b6bb4a50911200012s67b28e58g8109b71479ef4257@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOWmguS9lemAmui/h2Zk5om+5Yiw5omT5byA5paH5Lu255qE6Lev5b6E5Y+K5ZCN?=
	=?UTF-8?B?56ew?=
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in fs/open.c
   sys_open
             | --> do_sys_open
                          |--->  fd_install

Then fd is installed into file_fdtable

in fs/file_table.c
     fget_light/fget
            |----> fcheck_files

Then kernel get files from fd.

2009/11/20 Helight.Xu <helight.xu@gmail.com>:
> 在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
> 来找到相应打开文件的路径及其名字呢？
>
> --
> ---------------------------------
> Zhenwen Xu - Open and Free
> Home Page:      http://zhwen.org
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
