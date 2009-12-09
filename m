Return-Path: <linux-kernel-owner+w=401wt.eu-S966970AbZLIAUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966970AbZLIAUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966900AbZLIAUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:20:21 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:46932 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966774AbZLIAUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:20:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q6IwCgXACQ0QOBh5SAP73bQ8D0dyeVfaCnAfUAphFWdjbBzewnVMP81hUX1awQAj6C
         +q60P8UXO2Z/+AFMdpSJ0LK/kLG4DFNq+ebKyrxt/jxiu9cNR0Cch04l8exeAm34JtF3
         /Jb5ejqBYtsR26bLqA2Xn8x7WiGOLP3B67Rus=
MIME-Version: 1.0
In-Reply-To: <829197380912081511k2ad53053t1a1f73b6e8571f75@mail.gmail.com>
References: <20091208214246.GA21857@kroah.com>
	 <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
	 <37219a840912081502v3fdf1879xdb28e867eb82884c@mail.gmail.com>
	 <829197380912081511k2ad53053t1a1f73b6e8571f75@mail.gmail.com>
Date: Tue, 8 Dec 2009 19:20:24 -0500
X-Google-Sender-Auth: 6040e34295bdf10d
Message-ID: <37219a840912081620r1d34a13dpf3a36f83f82c9a67@mail.gmail.com>
Subject: Re: 2.6.27.40 build error
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 6:11 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Dec 8, 2009 at 6:02 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>> Yes -- please drop it for now.  I didn't actually send this for
>> 2.6.27.y anyway -- it must have gotten to you some other way.
>>
>> Devin, if 2.6.27.y needs this fix, can you please generate the
>> appropriate backport and test it before we resubmit?
>
> We would have to decide whether it's worth the effort to get a 2.6.27
> environment setup to do the necessary regression testing.  At this
> point, I would argue that driver was screwed up enough in 2.6.27 that
> I wouldn't be inclined to tell users it worked even with this one fix.
>
> Devin

Fine with me -- I'm glad the v4l-dvb development repositories hosted
on both linuxtv.org and kernellabs.com are backwards compatible with
recent kernels... :-)

I think all the crucial fixes (except for the pvrusb2 16k firmware
patch) are all merged into 2.6.31.y as of now... So, now we can focus
on new driver support for 2.6.32 :-)

Cheers,

Mike
