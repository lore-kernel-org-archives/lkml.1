Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZELQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZELQOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZELQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:14:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:36542 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZELQOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cRFENR7EJDTF031YCJN7c0428NcEXYeksEIHqkeOzH0URBQTHbdHG1c04nhsm1UKad
         fwyqIZTiXHGykmNwbWPfunUqktx9QdSyrxl2dJaIKebf3qw+WY8PjKAaG4Mg9DTGbwlw
         WCxfkOHbLr1aYvkPNkOiyUjr+GLCx2LMsfGYo=
MIME-Version: 1.0
In-Reply-To: <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com> 
	<3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com> 
	<20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Tue, 12 May 2009 21:43:47 +0530
Message-ID: <ea11fea30905120913y34586943y1567df47022ead50@mail.gmail.com>
Subject: Re: Help to edit inode content
To: ranjith kannikara <ranjithkannikara@gmail.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 9:32 PM, ranjith kannikara
<ranjithkannikara@gmail.com> wrote:
> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>> On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
>> <ranjithkannikara@gmail.com> wrote:
>>> Hi,
>>> I am a computer science engineering student. We have started a project
>>> to make an application to recover deleted files from an ext3
>>> filesystem. For that we have a doubt . Can we edit the inode content?

Hi,

yes you can. See the debugfs tool which comes with e2fsprogs. It
allows you to open a filesystem and then change the attributes of an
inode. It also has libext2fs which you can use to write programs
through its exported APIs.

Hope that helps

- Manish

>>> ie the recovery will be robust if we could edit the inode contents and
>>> give the pointer address manually or through a code. The inode is
>>> being created in the kernel mode and is it possible to edit those
>>> contents if the code is allowed to have the kernel mode permissions..?
>>
>> You'd probably be best off doing this in userspace, with the
>> filesystem unmounted.
> Of course we are doing it from another filesystem. ie only after
> unmounting the filesystem which is being worked on. in some case we
> make image of the filesystem to ensure security of data.
>> Generally speaking, don't attempt to alter the filesystem from
>> userspace while it is mounted.
>>
> But we would like to know whether it is possible to edit the inode
> because it will make the recovery easy and robust. ie he know the
> details of the inode of the file which had been deleted is it possible
> to edit the content of that inode with the pointers of the deleted
> file.?
> Regards
> Ranju.
>
>
>
> --
> http://www.ranjithkannikara.blogspot.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks -
Manish
