Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZEUSSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZEUSSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 14:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZEUSR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 14:17:58 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:40062 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZEUSR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 14:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r/kt49nhpPrqQ1FAm0vB6oYhPAJcXe9CSKAJTRwxN2P8X2IOfUCe1Di3ZKgq62AFEw
         caLLjmXo8gIK6xDRw0h03EeKMF5348QkjIqNnu9fxc8tisrBiw6Kj23gD5zbxG+hxWz5
         CcMVZtNvuyTs9w5tPz6G68XXFJ60WqRetBpy8=
MIME-Version: 1.0
In-Reply-To: <20090521161317.GU1376@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar>
Date: Thu, 21 May 2009 14:17:58 -0400
Message-ID: <87f94c370905211117y13758f72i2ea113c9c6771061@mail.gmail.com>
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data 
	integrity
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 12:13 PM, Alberto Bertogli
<albertito@blitiri.com.ar> wrote:
>
> Hi!
>
> I'm writing this device mapper target that stores checksums on writes and
> verifies them on reads.
>
> It's not widely tested, but you can run mke2fs on it and do basic file
> operations. The to-do list is still large, and most of it can be found within
> the code.
>
> To test it, you will need to format the device using the (very rough) attached
> tool, and then create the dm device with something like:
>
>        echo 0 $SIZE csum $REALDEVICE 0 | dmsetup create $NAME
>
>
> I think it can be useful for people who want to detect data corruption and are
> either using the block layer directly or a filesystem that doesn't check data
> integrity (which are most, if not all, of the popular ones today). Maybe it
> could also be used for testing the bio-integrity extensions, although at the
> moment it's completely independent and I haven't looked much, but it's on my
> to-do list.
>
> It does NOT pretend to be useful for consistency checks for security purposes.
> Use something else if you do not want someone evil tampering with your data.
>
>
> Comments are obviously welcome. There are also some questions embedded in the
> code, if anyone cares to answer any of them, I'd really appreciate it.
>
> Thanks a lot,
>                Alberto

I have not looked at your patch, but does this tie into the integrity
logic that was added to mainline a few months ago?

I'm not sure if it should or not, but I am curious how it ties in.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
