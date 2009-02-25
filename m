Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZBYPGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZBYPGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZBYPGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:06:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:50501 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBYPGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=CKScyNogKYCVx/FR++CSdtY781mbFedFlz8KI033epgiCDb0I3vLNIq+5dBq9cJbYy
         /0yM3ULvQcSl+p+aE+d5pbUh7KpT0iKoVeJvGYbalyaXmA9KxZxQjJhRy2rWbjt/3bNp
         jqmjKKsXDVMtBrHQ/2M1RcHJMUuo9Ys4ec2uY=
MIME-Version: 1.0
In-Reply-To: <20090225145950.GJ7064@mit.edu>
References: <49A4F06B.6030205@cn.fujitsu.com> <20090225145950.GJ7064@mit.edu>
Date: Wed, 25 Feb 2009 23:05:57 +0800
Message-ID: <a669f14b0902250705x4895b4b3sc9843d03466405bf@mail.gmail.com>
Subject: Re: Documentation:Update the INDEX of the documents
From: Yang Hongyang <imhy.yang@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Yang Hongyang <yanghy@cn.fujitsu.com>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-doc@vger.kernel.org, mtk.manpages@gmail.com, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 10:59 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Feb 25, 2009 at 03:16:59PM +0800, Yang Hongyang wrote:
>> There are so many 00-INDEX file that are missing description of the
>> current files in the dir.  Such as 00-INDEX in
>> Documentation/x86/,Documentation/networking/,Documentation/ and so
>> on.
>>
>> It's a large amount of work for someone to go through all these
>> documents and make summaries.
>>
>> I'm willing to do some of the work but if someone else pick these
>> up(especially the authors of these new files) it will be a great
>> help.^_^
>
> Before you embark on this large amount of work, we should probably ask
> a question first --- how useful are the 00-INDEX files?  I don't find
> them particularly interesting, given that my normal way of finding
> documentation in the Documentation directory is:
>
> find . -type f | xargs grep <keyword>
>
> Or, if I have a git tree of the Linux sources handy:
>
> git grep <keyword> -- Documentation
>
> If folks do find the 00-INDEX files useful, my suggestion would be to
> make a way of automatically extracting them from the individual files
> and/or directories, and then making the 00-INDEX files to be
> automatically generated.

Sounds a good idea to me.If nobody interested in the 00-INDEX files,
just remove it.

>
>                                                - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
