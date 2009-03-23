Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZCWJum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZCWJum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZCWJuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:50:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:49682 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZCWJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xkU/ATbF22Gn3zqKGfM0ahyUDKxuHRmNEpnTGOAxju8ALsk/jaJ0/wiUt7A3Pwop6A
         mL7Pg8BPArA+2eeu3fRlVLty9TV2Mn8ruiXT7f1o6R3ZZyroW5hTAbC4Sx6lyexsub+M
         1eJ1lC8uMICDqiTkgsorYydes3+1tYCAezew0=
MIME-Version: 1.0
In-Reply-To: <1225130422.4845.35.camel@gaiman.anholt.net>
References: <4905CFC3.1060907@tuffmail.co.uk>
	 <1225130422.4845.35.camel@gaiman.anholt.net>
Date: Mon, 23 Mar 2009 09:50:28 +0000
Message-ID: <9b2b86520903230250q15ffd726k8f20bb13f8321f22@mail.gmail.com>
Subject: Re: 2.6.28-rc1: [drm:i915] *ERROR* ... Disabling tiling
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Eric Anholt <eric@anholt.net>
Cc: dri-devel@lists.sourceforge.net,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/08, Eric Anholt <eric@anholt.net> wrote:
> On Mon, 2008-10-27 at 14:27 +0000, Alan Jenkins wrote:
>> What does this mean, should I do anything about it?  Is tiling nice to
>> have?
>>
>> It sounds like GEM broke something - though maybe it just added a more
>> verbose error report.
>>
>> System: EeePC 701
>> Kernel: v2.6.28-rc1-5-g23cf24c
>> Chipset: Intel mobile 915G-something
>> Regretably necessary kernel boot option: noapic
>>
>>
>> [    1.438441] Linux agpgart interface v0.103
>> [    1.438441] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
>> [    1.438441] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
>> [    1.443353] agpgart-intel 0000:00:00.0: AGP aperture is 256M @
>> 0xd0000000
>> [    1.443353] [drm] Initialized drm 1.1.0 20060810
>> [    1.443353] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5
>> (level, low) -> IRQ 5
>> [    1.443353] pci 0000:00:02.0: setting latency timer to 64
>> [    1.443353] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read
>> from MCHBAR.  Disabling
>> tiling.
>
> This means that something went wrong with our detection of the
> CPU-versus-GPU tiling swizzling mode, and object tiling under GEM will
> be disabled as a result.  I should get access to an eee 7xx on Thursday
> to see what's up with it -- it's supposed to be just a normal 915gm as
> far as I know.

Any news about this tiling error?

It's already been reported as a bug in Ubuntu Jaunty, in the belief
that it "reduces video performance" [1], and is also mentioned on a
similar bug in Fedora [2].

[1] <https://bugzilla.redhat.com/show_bug.cgi?id=444328#c37>
[2] <https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/329266>

Thanks
Alan
