Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbYHDTur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbYHDTur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbYHDTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:50:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:27192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbYHDTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ItheCphuyZm30VGOapyHFqYgJUvTo8UiIctB+NPKjTkFIF4ryshKxT0IG/uWKd9f6v
         tItc+a68aaBUmOD+Vmc+EgxoXSbgnBBo3OAZFiwGM30E9lo83j56fCzcnLZRWBQfehZm
         CvYALXEi+yUH/ihIVFwKIM1vSStvI+t8WT6UY=
Message-ID: <6101e8c40808041250u1d87d120l845b0cc6d07d62e3@mail.gmail.com>
Date: Mon, 4 Aug 2008 21:50:36 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] [RFC, 2.6.26.2-rc1] NFS: Ensure we call nfs_sb_deactive() after releasing the directory inode
Cc: "Willy Tarreau" <w@1wt.eu>, stable@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080804183623.GC20191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ec5c3df63eafa2691665b95e989d7c3c@zipernowsky.hu>
	 <20080802174220.GF615@1wt.eu> <20080804183444.GB20191@kroah.com>
	 <20080804183623.GC20191@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the fixed patches to get a "(fixed)"  ending

On 8/4/08, Greg KH <greg@kroah.com> wrote:
> On Mon, Aug 04, 2008 at 11:34:44AM -0700, Greg KH wrote:
>> On Sat, Aug 02, 2008 at 07:42:20PM +0200, Willy Tarreau wrote:
>> > Oliver,
>> >
>> > most of your mails are line-wrapped at some locations :
>> >
>> > > diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
>> > > index 3adf8b2..f089e58 100644
>> > > --- a/fs/nfs/unlink.c
>> > > +++ b/fs/nfs/unlink.c
>> > > @@ -95,10 +95,11 @@ static void nfs_async_unlink_done(struct rpc_task
>> > > *task, void *calldata)
>> > ^^^^^^^^
>> > see here.
>> >
>> > You may have to fix your mailer (or use another one).
>>
>> {sigh}
>>
>> Yes, all of these patches are linewrapped.
>
> Ok, I take that back, only half of them are linewrapped :)
>
> But it would be easier for you to just resend them all, as that way I
> know which ones have already been rejected by people much easier and I
> can take the proper ones.
>
> thanks,
>
> greg k-h
>


-- 
Thanks,
Oliver
