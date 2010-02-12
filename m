Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab0BLTkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:40:07 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:63736 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0BLTkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T/rUNti4cP1QOpr3D9a7VMPrn3fth6VS7TK3ClfYLFiHneoAffLHapFgm8XdjYSKGG
         IMYkemDF5lL+EdNnZHU4PB+tdTYERdamA+p1YM93M4J/4tS9UolulvutfU4tqlr5NZOY
         isFyksuw9rA3JfhqA3U6/btb+UIZgQ/3MZ66k=
MIME-Version: 1.0
In-Reply-To: <20100212184756.GA14751@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E883CB@TK5EX14MBXC118.redmond.corp.microsoft.com> 
	<20100211233612.GB10315@suse.de> <8AFC7968D54FB448A30D8F38F259C56212E88B0F@TK5EX14MBXC118.redmond.corp.microsoft.com> 
	<20100212184756.GA14751@suse.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 12 Feb 2010 11:39:44 -0800
Message-ID: <43e72e891002121139y4bb4fbc2mdfc99f3b7ad6ebef@mail.gmail.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add proper versioning to HV 
	drivers-Corrected.
To: Greg KH <gregkh@suse.de>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 10:47 AM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Feb 12, 2010 at 05:55:34PM +0000, Hank Janssen wrote:
>>
>> > >
>> > >  drivers/staging/hv/VersionInfo.h |   22 +++++++++++++++++++---
>> >
>> > You forgot a "---" between the signed-off-by and the diffstat.  If you
>> > use either git or quilt, it will get this correct automagically.  That
>> > infers you used something else, which is quite scary.  What are you
>> > using instead to create patches?
>> >
>> > Don't worry, I can edit this by hand when I apply it, and will do so in
>> > a few days when I get to my "to-apply" queue, but in the future, please
>> > don't do this.
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>> This must have been the result of a cut/paste error on my side.
>>
>> I use the following command for my diff   'git diff -M -u --stat'
>
> What's wrong with 'git format-patch'?
>
> You are creating a "raw" diff, which is fine, but you then need to
> include the rest of the comments.  If you commit the patch to a branch,
> with the comments in them, then you can just automatically create the
> patches in correct format.

In case this helps:

http://wireless.kernel.org/en/developers/Documentation/git-guide

Toward s the end there is a git format-patch blurb and explains how to
set up your e-mail client with ssmpt.

  Luis
