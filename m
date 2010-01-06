Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061Ab0AFSGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0AFSGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053Ab0AFSGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:06:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45043 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab0AFSGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TmDeL4rtu4HcpzEtaVzwGKOoPUv/habD57P3uzP1rFRg/zFI7ftgENXZqIRPO72885
         K9Fy/lyXLE+EdF3jM5WeT82U+wx1qmIJC6xHDWWcJAWAuGY6NuA8sVxYMj5d6fnQwVfA
         EgcP3l6Ci4L10ph6PpnbSIUStLSzibkjI+WEI=
MIME-Version: 1.0
In-Reply-To: <20100106185913.39003329@neptune.home>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
	 <20100106185913.39003329@neptune.home>
Date: Wed, 6 Jan 2010 13:06:46 -0500
Message-ID: <a44ae5cd1001061006i63579096me4d598b06cc358f9@mail.gmail.com>
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images 
	displayed are side by side (should only show one).
From: Miles Lane <miles.lane@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 12:59 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> On Wed, 06 January 2010 Miles Lane <miles.lane@gmail.com> wrote:
>> For a long time I have gotten two pictures of Tux showing up when I
>> include the Tux display option in my custom kernel builds.  I don't
>> know how many kernel revisions ago it was when I started noticing
>> this.  It seems like it might have been early in the 2.6 series
>> kernels.
>
> Unless your system has exactly one CPU without hyperthreading and with
> exactly one core this is the correct bahavior, one tux per logical CPU.
>
> If you just want a single tux you can run your kernel on a system with
> only one logical CPU, boot it with maxcpus=1 or rebuild it with
> CONFIG_SMP=n... though in those case you will not be able to benefit
> from all of your CPU's resources..
>
> Bruno

Oh!  Well, that explains it.  That is truly weird functionality.  Is
Tux a de facto
CPU presence indicator?  It doesn't make any sense to me, if so.

         Miles
