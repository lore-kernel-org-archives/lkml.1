Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZEMELi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZEMELi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZEMELX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:11:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:26263 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZEMELW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vmvr7oNommyGSFryoGErhZwCGIxzhQJbaEX+TMKmjOrHkDuFD8ViDqwVsalhK6746S
         yCWfcv4V3QqD/QnsGTTYWUMAy1z3W6uUh/WPiUz9rWpQADPrUUbN5TBlCXohIqsyZdfy
         9ciYTYKzhv+d2cM580STeF+pPRdrImDeE++Bs=
MIME-Version: 1.0
In-Reply-To: <20090512200310.GP3209@webber.adilger.int>
References: <20aa8c370905120847j4b19175akbdcafc0db2004567@mail.gmail.com>
	 <3e8340490905120856w62c6c5cexa247937bf7e84002@mail.gmail.com>
	 <20aa8c370905120902o71ab9adflb8619e2a9ae343d0@mail.gmail.com>
	 <20090512200310.GP3209@webber.adilger.int>
Date: Wed, 13 May 2009 09:41:22 +0530
Message-ID: <20aa8c370905122111x6bc80d4ave0c857fafd8d9e0a@mail.gmail.com>
Subject: Re: Help to edit inode content
From: ranjith kannikara <ranjithkannikara@gmail.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 1:33 AM, Andreas Dilger <adilger@sun.com> wrote:
> On May 12, 2009  21:32 +0530, ranjith kannikara wrote:
>> On Tue, May 12, 2009 at 9:26 PM, Bryan Donlan <bdonlan@gmail.com> wrote:
>> > On Tue, May 12, 2009 at 11:47 AM, ranjith kannikara
>> > <ranjithkannikara@gmail.com> wrote:
>> >> I am a computer science engineering student. We have started a project
>> >> to make an application to recover deleted files from an ext3
>> >> filesystem. For that we have a doubt . Can we edit the inode content?
>> >> ie the recovery will be robust if we could edit the inode contents and
>> >> give the pointer address manually or through a code. The inode is
>> >> being created in the kernel mode and is it possible to edit those
>> >> contents if the code is allowed to have the kernel mode permissions..?
>>
>> But we would like to know whether it is possible to edit the inode
>> because it will make the recovery easy and robust. ie he know the
>> details of the inode of the file which had been deleted is it possible
>> to edit the content of that inode with the pointers of the deleted
>> file.?
>
> Are you asking whether it is possible to modify the on-disk structure
> of the ext3 inode? Generally that is NOT allowed because it will of
> course break all existing filesystems if not done with extreme care.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
Hi,
Actually I was asking the same. whether it is possible to edit the
inode content of a disk or the image of a disk. Did you mean that it
is not possible at all. Is there any method to edit the inode content
and use the edited inode for a file, If we can ensure high care.
because such a method will be the most robust one in the recovery of
deleted file.

Regards
ranju.

-- 
http://www.ranjithkannikara.blogspot.com/
