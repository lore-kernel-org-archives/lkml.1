Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYDJPCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYDJPCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbYDJPBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:01:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:31223 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759321AbYDJPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P6rTckGzMNPZ9eZ+twiGu0qsBUVu42RYY1jdxygkLpHvgWwaebDw8Ou/K+PdC+h4Tgi/ZOZU8lszZgbvggil/CPmXGwna77aLuSEaJ7NvdloB8IgWh23iLPEHwV3KlSuXWu6CZDXbgCa765Ufjs4S8/IJ5lzw0QbFEIdSHK9Cg4=
Message-ID: <bb145bd20804100801y157b4a34m82f084d27f1e0586@mail.gmail.com>
Date: Thu, 10 Apr 2008 17:01:38 +0200
From: "Christian Pernegger" <pernegger@gmail.com>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: Western Digital GreenPower drives and Linux
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1207831481.1514.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804092118.35501.tvrtko@ursulin.net>
	 <200804100848.08442.tvrtko@ursulin.net>
	 <1207831481.1514.8.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Keep me CCd on this, please. ]

>  Those fancy new WD GreenPower drives seem to be heavily suffering from the
>  rapidly increasing head load/unload problem. [...] I got one of them
>  (WD5000AACS) recently and to my horror [...]

I have the same disks, only with more warranty and supposedly
"enterprise" firmware (WD1000FYPS). The bug is the same, though, on
all four of them (~ 9 cycles /hour):

  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       917
193 Load_Cycle_Count        0x0032   198   198   000    Old_age
Always       -       8025

  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       906
193 Load_Cycle_Count        0x0032   198   198   000    Old_age
Always       -       7908

  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       907
193 Load_Cycle_Count        0x0032   198   198   000    Old_age
Always       -       8051

  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       918
193 Load_Cycle_Count        0x0032   198   198   000    Old_age
Always       -       7869

>  I got the _DOS_ utility from WD which issues vendor specific commands to
>  control that feature.

Have they confirmed it's a bug? I have no idea how often the disks
should do that.

>  [...] With it the unload feature can be either disabled or timer set from
>  100ms to 25.5 seconds. But obviously I can't try it...

Why? Using a DOS boot disk once would not be that bad as a workaround,
would it? Or is the setting not persistent? Either way I'd prefer to
be able to leave the feature on (in usable form), eventually.

The bigger question is - why the rapid loads / unloads? In my case the
disks are idle hours at a time. No system files on there, just bulk
data. Does / could the controller (sata_sil24 in my case) have any
influence on this kind of power management?

Thanks,

C.
