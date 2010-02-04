Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab0BDTfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:35:01 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:44199 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab0BDTe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h5b+zcK801DoX1qBHua30fPx4hZUPkBEjtKu2lO3Qjxr9PdXmwUJ4uM6KIJ50ddukV
         W7ETwbGDSdmi5aO1t4r03rmnPBOu7IH73m8zmcuZKpZGLSHuYWEbE27J/1iM7ab6yPHb
         cKXSY6jn1TrXrE3tnrUykuNwtcaUnlzj0EXGA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002041123400.3707@localhost.localdomain>
References: <21d7e9971002021234y275fae02k410af92bb16fee73@mail.gmail.com>
	 <20100204170826.GA16397@elte.hu>
	 <20100204173602.GA19855@srcf.ucam.org>
	 <20100204175445.GB27361@elte.hu>
	 <20100204175928.GA20595@srcf.ucam.org> <20100204181218.GA6175@elte.hu>
	 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
	 <20100204190649.GB6665@elte.hu>
	 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
	 <alpine.LFD.2.00.1002041123400.3707@localhost.localdomain>
Date: Fri, 5 Feb 2010 05:34:53 +1000
Message-ID: <21d7e9971002041134m7e4d1a8dif65ccee8b7fbc203@mail.gmail.com>
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch 
	out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 5:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 4 Feb 2010, Alex Deucher wrote:
>>
>> And if it crashes, he'll report a bug and we'll fix it.
>
> Ok, you have a bug-report. See earlier in the thread:
>
>> btw., i just found another bug activated via this same commit, a boot hang
>> after DRM init:
>>
>> [    9.858352] [drm] Connector 1:
>> [    9.861417] [drm]   DVI-I
>> [    9.864031] [drm]   HPD1
>> [    9.866562] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
>> [    9.872579] [drm]   Encoders:
>> [    9.875540] [drm]     CRT2: INTERNAL_DAC2
>> [    9.879541] [drm]     DFP1: INTERNAL_TMDS1
>> [    9.883646] [drm] Connector 2:
>> [    9.886695] [drm]   S-video
>> [    9.889483] [drm]   Encoders:
>> [    9.892463] [drm]     TV1: INTERNAL_DAC2
>> [    9.896392] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
>> [    9.901796] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
>> [    9.909246] i2c i2c-0: NAK from device addr 0x50 msg #0
>> [    9.914564] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
>> [    9.919957] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
>> [    9.927413] i2c i2c-1: NAK from device addr 0x50 msg #0
>
> So can we get it fixed, please?

Ingo,

got the full dmesg? and lspci -vvnn

the bug reporting needs work, this snippet hasn't the useful info in it.

Dave.

>
>                Linus
>
> ------------------------------------------------------------------------------
> The Planet: dedicated and managed hosting, cloud storage, colocation
> Stay online with enterprise data centers and the best network in the business
> Choose flexible plans and management services without long-term contracts
> Personal 24x7 support from experience hosting pros just a phone call away.
> http://p.sf.net/sfu/theplanet-com
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
