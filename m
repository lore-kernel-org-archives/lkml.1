Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZEGDii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZEGDii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZEGDi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:38:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:54961 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZEGDi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hNWTZDOCXLVZYrcr09YCsGFQT9j5PwiPQ0vDEU0aaqwzDxHsWJXLdKZeMU9dJHQXrM
         CZSlUVA8GSFujvlqJW9sThiZZ/z7LTLJbHDevINHktueluQzEotNKMCPQLL+yzSVT3Zv
         qiLeVPknixcCvOSg7jk3T+vZHFTN/W14YabXw=
MIME-Version: 1.0
In-Reply-To: <20090506113132.6ca2d7a3@hobbes>
References: <a44ae5cd0905052049i2f4cfdeia64fb1c147c4da67@mail.gmail.com>
	 <a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
	 <a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
	 <20090506112132.3fd44b34@hobbes>
	 <a44ae5cd0905061125w4044fd50l6f30a1ca9a5b1396@mail.gmail.com>
	 <20090506113132.6ca2d7a3@hobbes>
Date: Wed, 6 May 2009 23:38:28 -0400
Message-ID: <a44ae5cd0905062038ta32b7a2qc745cfe45b42f98d@mail.gmail.com>
Subject: Re: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting is 
	locking up my system when Xorg starts.
From: Miles Lane <miles.lane@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ubuntu instructions did the trick.
I have it working (mostly) now.  Thanks a lot for your help.

        Miles

On Wed, May 6, 2009 at 2:31 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 6 May 2009 14:25:46 -0400
> Miles Lane <miles.lane@gmail.com> wrote:
>
>> Yes, the framebuffer console works fine if I boot "single".  Then, the
>> system hangs when I run xinit.
>> I will check out the page on the Ubuntu site. Thanks!
>
> Ok, my guess is that xf86-video-intel is doing something bad since it's
> not built with KMS support.  The Ubuntu site should help with that
> though.
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
