Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZJHFzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZJHFzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZJHFzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:55:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47522 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZJHFzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ec8gAyP06JaYxaC0rO24MwOHCig3oNJ9wZySmwCXNac9Pwo0PNwhGp0DELBtGb8+GL
         C75OFe0aFwDItJJ1gjNd12WtqhDU8cGsLpejOH41B3e5JwOEjxFbFlqQFqRQgvSPQwPg
         gQsaftZJvO0nET+zbpnNfNS1HTobZHSXvCS08=
MIME-Version: 1.0
In-Reply-To: <haj8uj$fn8$2@ger.gmane.org>
References: <haj471$fn8$1@ger.gmane.org>
	 <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
	 <haj8uj$fn8$2@ger.gmane.org>
Date: Thu, 8 Oct 2009 13:55:01 +0800
Message-ID: <a8e1da0910072255r38f95e59lf9559b4ecd1cc9d2@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Dave Young <hidave.darkstar@gmail.com>
To: Jack Byer <ojbyer@usa.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 7:42 AM, Jack Byer <ojbyer@usa.net> wrote:
> Paul Hartman wrote:
>
>> On Wed, Oct 7, 2009 at 5:22 PM, Jack Byer <ojbyer@usa.net> wrote:
>>> I have a CD of a commercial software program that I am attempting to run
>>> under wine. The CD works without problems under Windows, but when I mount
>>> it on linux the file system appears to be empty (no files or
>>> directories). The drive is capable of reading the CD because "strings
>>> /dev/cdrom" works.
>>>
>>> What would I need to do in order to troubleshoot this problem?
>>
>> Maybe try mounting with the "-o unhide" option. Or maybe it is a
>> multi-session disc?
>
> -o unhide does not help. Can a factory-pressed disc be multisession? It's
> not a CD-R

Could you post the header part of the cd? ie:

dd if=/dev/cdrom of=header bs=1k count=32

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
