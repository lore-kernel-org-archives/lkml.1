Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZELQC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZELQC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZELQCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:02:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:11342 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZELQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qkIDoV6xqeZH16H1Efj+6OMbNhuc04z/SxGCeQIrNugb4p566sjugm41CehSBt2+SV
         YMEV1DsxdzAkyN9I0R7Nfro82bB+nkdG4tEqHePNy8l98R6sq0DMsdzO0pGnVz2iAkHi
         UiKZRJ3MhFrtLlJ5EjHHlF9ygjYVSLZJk1dzo=
MIME-Version: 1.0
In-Reply-To: <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	 <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
Date: Tue, 12 May 2009 21:32:16 +0530
Message-ID: <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
Subject: Re: Help to edit inode content
From: ranjith kannikara <ranjithkannikara@gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
> On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
> <ranjithkannikara@gmail.com> wrote:
>> Hi,
>> I am a computer science engineering student. We have started a project
>> to make an application to recover deleted files from an ext3
>> filesystem. For that we have a doubt . Can we edit the inode content?
>> ie the recovery will be robust if we could edit the inode contents and
>> give the pointer address manually or through a code. The inode is
>> being created in the kernel mode and is it possible to edit those
>> contents if the code is allowed to have the kernel mode permissions..?
>
> You'd probably be best off doing this in userspace, with the
> filesystem unmounted.
Of course we are doing it from another filesystem. ie only after
unmounting the filesystem which is being worked on. in some case we
make image of the filesystem to ensure security of data.
> Generally speaking, don't attempt to alter the filesystem from
> userspace while it is mounted.
>
But we would like to know whether it is possible to edit the inode
because it will make the recovery easy and robust. ie he know the
details of the inode of the file which had been deleted is it possible
to edit the content of that inode with the pointers of the deleted
file.?
Regards
Ranju.



-- 
http://www.ranjithkannikara.blogspot.com/
