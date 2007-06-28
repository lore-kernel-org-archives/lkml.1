Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbXF1DW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbXF1DW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbXF1DWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:22:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbXF1DWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JP8+tOp5+ZjuniI6eSwG5YVzdinyGuZ5seAbK5NJ8cp5zUQR8K8AiTVaOC38PGPCbe+hBmGhbJLwPKjdCT/TuAECUeQ8sl/zC+ZjTc/ALBAVkbCcBk1TfTF4wMARIYCdSjM9W82+2npprGf1SLFCJQmKeN6rrlMpwtnZGe3vO/o=
Message-ID: <75b66ecd0706272022i272669f7i1e0c9c8931f8b700@mail.gmail.com>
Date: Wed, 27 Jun 2007 23:22:18 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Patrick Draper" <pdraper@gmail.com>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Cc: "Rene Herman" <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4683252B.9010205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706271825.17459.ahartmetz@gmail.com>
	 <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com>
	 <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com>
	 <468315AF.1080105@gmail.com> <4683252B.9010205@gmail.com>
X-Google-Sender-Auth: 206c451a3398a071
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Patrick Draper <pdraper@gmail.com> wrote:
> Rene Herman wrote:
> > So -- the fact that mixing actually works for you when using libaoss
> > means software mixing is working correctly for your ALSA setup. The only
> > thing you should do is _use_ ALSA (natively) and not its OSS emulation
> > so you can drop the library preload.
>
> Cool. How do I go about figuring out what every app uses? For example,
> you mentioned that the flash 9 plugin, which I also use, is an ALSA
> aware application. How do you know? I need the check out everything that
> I use which needs sound (vmware, skype, kmplayer, etc.) I don't have
> source code for at least two of those.

Go into the sound preferences menu of the app and check which device
it uses.  If it's something like /dev/dsp or /dev/audio it's using
OSS.  If it looks like "default" or "hw:0" it's ALSA.

If your app does not have any sound preferences menu it's broken and
you should file a bug report.

You can determine whether an app with no configurable sound device is
using ALSA by running "strace broken_app" and grep the output for
"/dev/dsp" or "/dev/audio".

Lee
