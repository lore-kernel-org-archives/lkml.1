Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZDON04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZDON04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDON0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:26:46 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64336 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZDON0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mhFXRitb5BaKhSlbDhOYRfowVmx+TizS9Xn+GP4F9AsrTMh07NxkUUA/PExatUNfy7
         EnYis/5ZaOyVGiwgYPZ4wfKV1YjegmU4Ba+Z58WIV2ceaYc9e6A1hBZTrotFigINIsTs
         5woGddsmORyTyCSL1u8RFifmbovcr/LrZooaI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904141851570.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
	 <1239759779.2567.817.camel@ymzhang>
	 <alpine.LFD.2.00.0904141851570.4132@localhost.localdomain>
Date: Wed, 15 Apr 2009 15:26:43 +0200
Message-ID: <5a4c581d0904150626g466090bcn9a2e03b0c4347efb@mail.gmail.com>
Subject: Re: Linux 2.6.30-rc2
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 4:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 15 Apr 2009, Zhang, Yanmin wrote:
>>
>> There are lots of conflictions when I apply it to 2.6.29.
>>
>> Bleow are just some.
>>
>> patching file arch/arm/configs/xm_x2xx_defconfig
>> Hunk #1 FAILED at 1.
>> Hunk #2 succeeded at 62 (offset -1 lines).
>
> Damn.
>
> It patches just fine if you use "git apply".
>
> The problem? I had enabled rename detection in my .gitconfig due to
> testing a git patch, and forgotten all about it. So when I generated the
> patch, it had rename detection on. And so part of the patch looks like
>
>        diff --git a/arch/arm/configs/xm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
>        similarity index 83%
>        copy from arch/arm/configs/xm_x2xx_defconfig
>        copy to arch/arm/configs/cm_x2xx_defconfig
>        index 1039f36..797b790 100644
>        --- a/arch/arm/configs/xm_x2xx_defconfig
>        +++ b/arch/arm/configs/cm_x2xx_defconfig
>        @@ -1,7 +1,7 @@
>         #
>         # Automatically generated make config: don't edit
>        -# Linux kernel version: 2.6.27-rc8
>        -# Sun Oct  5 11:05:36 2008
>        +# Linux kernel version: 2.6.29-rc2
>        +# Sun Feb  1 16:31:36 2009
>         #
>         CONFIG_ARM=y
>        ...
>
> and other parts just contain pure renames, and "patch" obviously won't
> understand any of that.
>
> My bad. I didn't mean to leave people without git out in the rain. I've
> re-uploaded a fixed one that doesn't have those git features..
>
> Alessandro - did you also do things by applying that patch? Maybe your
> compile failure can be explained by the same thing, and just comes from
> not noticing the patch apply failure.

Must have been that for sure... I re-downloaded the patch and
 successfully rebuilt 2.6.30-rc2, thanks !

> Sorry about that. The fixed patch is on master.kernel.org and should be
> mirroring out asap. And I've fixed my .gitconfig, and hopefully this won't
> happen again.
>
>                Linus


--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
