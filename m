Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYJ1MWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYJ1MWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJ1MV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 08:21:59 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:48992 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYJ1MV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 08:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hU9NnVnhus/H2R+gpV3UZxZyXzvncplbPOEw7UP1ab1ULiHZmtO40GfUS1MvQ2EpUD
         tDQZTURQ5Dq+2KTQkOw/W88TJS3OMfBEWsl7uOMFKP7g0PHA3M6yAtQqxrqsnAbz76au
         oX/Vy9Zjy346xAp5J72qhQwUb9B+3VsRZ+jBI=
Message-ID: <f17812d70810280521g7cbf53b6kda2e7a1f7eef4de7@mail.gmail.com>
Date: Tue, 28 Oct 2008 20:21:57 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Liam Girdwood" <lrg@kernel.org>
Subject: Re: [PATCH] da903x regulator bug fix
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>,
       "Jonathan Cameron" <Jonathan.Cameron@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225192778.28382.137.camel@dell-desktop.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4901EE0F.5000508@cam.ac.uk> <4905DE3D.1010101@gmail.com>
	 <f17812d70810271801t47830712h431df82baee11654@mail.gmail.com>
	 <f17812d70810271802v75b08712l4ab243802f59ecce@mail.gmail.com>
	 <4906F194.30901@cam.ac.uk>
	 <1225192778.28382.137.camel@dell-desktop.example.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 7:19 PM, Liam Girdwood <lrg@kernel.org> wrote:
> On Tue, 2008-10-28 at 11:03 +0000, Jonathan Cameron wrote:
>> Changes the device registration part of the probe function to supply the
>> regulator device rather than its parent (the mfd device) as this caused
>> problems when the regulator core attempted to find constraints associated
>> with the regulators.
>>
>> Signed-of-by: Jonathan Cameron <jic23@cam.ac.uk>
>
> Thanks, this is more preferable than the first patch. I would ultimately
> prefer this regulator to be more like wm8350 in terms of mfd
> registration but we are in rc2 so this will have to wait.
>
> Eric, would you like to Ack ?
>

Yeah, I'm fine with this.

Acked-by: Eric Miao <eric.miao@marvell.com>

> Thanks
>
> Liam
>
>
>



-- 
Cheers
- eric
