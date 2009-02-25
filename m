Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbZBYVzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbZBYVzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZBYVyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:54:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:19453 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbZBYVyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lmGegasZFE8W7vbh0Jf/7Cg4Q6shwMPBapEs9ATMVgv2bloMRsn08PRMiAARsfA46j
         jI4t+xONPBRYTu+BFgKAJ2mJ/b0FnNJbdTMDoaBkiFk8YVgbOdpyhsKgF/EqXXAbaL3z
         yM7aFflmcu4Y8PvuaYryOymXuoZtC+RIUKRGo=
MIME-Version: 1.0
In-Reply-To: <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
	 <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
	 <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
	 <e9c3a7c20901160939y6b3906fp41531730d4b752a@mail.gmail.com>
	 <Pine.LNX.4.64.0901162048400.9060@axis700.grange>
	 <4974F208.3020407@intel.com>
	 <Pine.LNX.4.64.0901201048090.5126@axis700.grange>
	 <Pine.LNX.4.64.0902191533090.5156@axis700.grange>
	 <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
Date: Wed, 25 Feb 2009 14:54:48 -0700
X-Google-Sender-Auth: d5aa2764baf53147
Message-ID: <e9c3a7c20902251354x5512c222h41c2c9ebfa290e0b@mail.gmail.com>
Subject: Re: [PATCH 3/4 v9] i.MX31: framebuffer driver
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 11:36 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, 2009-02-19 at 07:41 -0700, Guennadi Liakhovetski wrote:
>> Please, oh, please, wake me up if I'm dreaming... In the patch below all
>> the indentation in _both_ mx3fb.h and mx3fb.c is with TABs (ok, didn't
>> check all, a couple). Nun im Linus' git-tree - _ALL_ (that I checked)
>> indentation is with... BLANKS!!!??? Could someone, please, tell me what
>> was in that cup of tee I've drunk an hour ago?... Dan, you pushed this
>> patch via your tree, right? Could you double-check, please?
>>
>
> What a mess.  The other patches in your series were applied and
> checkpatched from the tarball you sent.  This last fix up patch was not
> cc'd to lkml so I fell back to applying it from a saved Thunderbird
> message.  The real issue is that I did not have checkpatch automated
> from StackedGIT's import command.  Please double check the fix below...
>

Sascha,

Will you be taking this clean-up through your tree?  I don't think it
is suitable for 2.6.29 and in my opinion it belongs with other IMX
platform driver fixups targeted for 2.6.30.

Thoughts?

--
Dan
