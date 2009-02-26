Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZBZSlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZBZSlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZBZSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:41:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:36350 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZBZSla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:41:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DF+DQQzo8nLLNOg+w6qlzEckyt2S6NfxZhdNZgJl59V8xH6gH3W3uvYZMmj1DedD9t
         CUP36pDy/1+sOcv76HLuYoNfphfBR7DRhIVmDa5QT7zUcSGJfHKLmmP2AXG95QLer2qe
         27INBCcK7hsPWWHw57caJJA20bx3WoFBYCx34=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902260833001.5238@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
	 <Pine.LNX.4.64.0901161106100.4940@axis700.grange>
	 <e9c3a7c20901160939y6b3906fp41531730d4b752a@mail.gmail.com>
	 <Pine.LNX.4.64.0901162048400.9060@axis700.grange>
	 <4974F208.3020407@intel.com>
	 <Pine.LNX.4.64.0901201048090.5126@axis700.grange>
	 <Pine.LNX.4.64.0902191533090.5156@axis700.grange>
	 <1235068604.18650.16.camel@dwillia2-linux.ch.intel.com>
	 <e9c3a7c20902251354x5512c222h41c2c9ebfa290e0b@mail.gmail.com>
	 <Pine.LNX.4.64.0902260833001.5238@axis700.grange>
Date: Thu, 26 Feb 2009 11:41:27 -0700
X-Google-Sender-Auth: 27bea1e6a7d2929c
Message-ID: <e9c3a7c20902261041t7e483c24m1151b89d79b5f718@mail.gmail.com>
Subject: Re: [PATCH 3/4 v9] i.MX31: framebuffer driver
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:37 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 25 Feb 2009, Dan Williams wrote:
>
>> On Thu, Feb 19, 2009 at 11:36 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Thu, 2009-02-19 at 07:41 -0700, Guennadi Liakhovetski wrote:
>> >> Please, oh, please, wake me up if I'm dreaming... In the patch below all
>> >> the indentation in _both_ mx3fb.h and mx3fb.c is with TABs (ok, didn't
>> >> check all, a couple). Nun im Linus' git-tree - _ALL_ (that I checked)
>> >> indentation is with... BLANKS!!!??? Could someone, please, tell me what
>> >> was in that cup of tee I've drunk an hour ago?... Dan, you pushed this
>> >> patch via your tree, right? Could you double-check, please?
>> >>
>> >
>> > What a mess.  The other patches in your series were applied and
>> > checkpatched from the tarball you sent.  This last fix up patch was not
>> > cc'd to lkml so I fell back to applying it from a saved Thunderbird
>> > message.  The real issue is that I did not have checkpatch automated
>> > from StackedGIT's import command.  Please double check the fix below...
>> >
>>
>> Sascha,
>>
>> Will you be taking this clean-up through your tree?  I don't think it
>> is suitable for 2.6.29 and in my opinion it belongs with other IMX
>> platform driver fixups targeted for 2.6.30.
>
> __NO__. Please don't. Dan, can you please get my original patch somehow in
> its _original_ form - with TABs and spaces as they were? Please, fix your
> mailer or get another one. In this patch you fixed all spaces at the
> beginning of lines, but not indentation inside lines. E.g.
>
> -#define MX3FB_NAME             "mx3_sdc_fb"
> +#define MX3FB_NAME             "mx3_sdc_fb"
>
> the first line (with spaces) is after applying this your patch to the
> current tree, the below line (with TABs) is my original version. Please,
> fix!
>

Like I said earlier, because this was not cc'd to lkml I do not have
access to the original with a sane mail system.  I actually think the
incoming Exchange server may have done the tabs to spaces conversion
[1] because even retrieving the message with mutt over imap has
issues.  Please resend v9 and cc lkml, then I will do a
revert/reapply.

--
Dan

[1]: http://support.microsoft.com/kb/945870
