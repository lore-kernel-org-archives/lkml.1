Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZIUOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZIUOR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZIUOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:17:58 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47201 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbZIUOR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iZPjs64ZwSJ2ab3AE3vhpB4JxRJOCcw2cbqDSYhckpV/G3Cbze9dvWPhA/t1CdV6H+
         OgunYKtZngrmX9YyxZw6S3JPIM8XBLWWvSPqlZpVQDiOq+2H1DvQL/RCyw5TeTNEEYCn
         c6sen7EHsJ1e58NCL+cJiCMxh4cCMaFisJPWg=
MIME-Version: 1.0
In-Reply-To: <200909210759.22008.edt@aei.ca>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie>
	 <200909210759.22008.edt@aei.ca>
Date: Mon, 21 Sep 2009 10:17:59 -0400
Message-ID: <a728f9f90909210717j11bfa6f3s395e078ed7ac62dd@mail.gmail.com>
Subject: Re: [git pull] drm tree.
From: Alex Deucher <alexdeucher@gmail.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 7:59 AM, Ed Tomlinson <edt@aei.ca> wrote:
> On Monday 21 September 2009 01:12:54 Dave Airlie wrote:
>>
>> Hi Linus,
>>
>> Please pull the 'drm-linus' branch from
>> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>>
>> This contains the main chunk of the drm changes for 2.6.32, I think Eric
>> has been on holidays for a week so I'd expect some more Intel changes
>> incoming in the merge window. It also contains a few merges for things
>> that were conflicting with things I sent to you via the drm-fixes tree,
>> but they weren't always trivial.
>>
>> Major highlights core drm/non-kms:
>> move mga/r128/radeon to firmware loader - major LOC churn,
>> decreases in-memory radeon module footprint quite a bit.
>> r600 3D support in non-kms mode.
>
> Dave,
>
> What user space stuff (xorg/mesa) is required to use the R300 3D?
>

r300 3D has been available for years.  If you mean r600 3D, you need
xf86-video-ati 6.12.4 or newer and mesa from git master.

Alex

> TIA,
> Ed Tomlinson
>
>> VGA arbitration support for core drm and kms (was waiting for
>> jbarnes tree to land).
>>
>> core KMS:
>> add support for GTF/CVT/DMT modes, gets us a long way towards X
>> merge intel and radeon kms framebuffer implementations for sanity.
>>
>> radeon KMS:
>> R600 KMS support + acceleration support.
>> move to generating the safe register tables with a script.
>> radeon tv-out supported ported from userspace
>> rn50/r100/r200 command submission trackers added
>>
>> intel:
>> some IGDNG fixes
>> important fix for wrapping at end of ring
>> more SDVO tv-out support
>> dynamic clocking support
>>
>
> ------------------------------------------------------------------------------
> Come build with us! The BlackBerry&reg; Developer Conference in SF, CA
> is the only developer event you need to attend this year. Jumpstart your
> developing skills, take BlackBerry mobile applications to market and stay
> ahead of the curve. Join us from November 9&#45;12, 2009. Register now&#33;
> http://p.sf.net/sfu/devconf
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
