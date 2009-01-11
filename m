Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZAKWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZAKWEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbZAKWEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:04:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65522 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKWEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=lufmGkH9DK44YMH8qeUzIAWU4PG7sPwI/5SKf6dW0QPJlTS1SvqTewpaz+OBKeoCR4
         TIsUeE+0SMWipQj/G/jborS0vp+pu8oP2OwcdCdp9rAalKT9ed1oEC74kWkepHtYnMsI
         mIuFA+4MngobSczimaaeOiFPDgYLTwU1qPpQo=
Date: Sun, 11 Jan 2009 23:04:06 +0100
From: Diego Calleja <diegocg@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Jan Dittmer" <jdi@l4x.org>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Message-ID: <20090111230406.756b3d9e@diego-desktop>
In-Reply-To: <21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com>
	<621d098f0901110551v5a05f69aqc4e06a6905989d6e@mail.gmail.com>
	<20090111222122.4d0cb146@diego-desktop>
	<21d7e9970901111339q705bcea4i44941bfd84a075fe@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 12 Jan 2009 07:39:29 +1000, "Dave Airlie" <airlied@gmail.com> escribió:

> On Mon, Jan 12, 2009 at 7:21 AM, Diego Calleja <diegocg@gmail.com> wrote:
> > I also have a failure with KMS, it's different than yours but I'll post it
> > in this thread...xserver-xorg-video-intel version 2.5.1 (whatever there is
> > in ubuntu unstable repositories)
> 
> Read the kconfig option before you enabled kms by default?
> 
> if not, you cannot just enable kms and have old userspace drivers
> work, there is no
> released userspace for this yet, as that would put the chicken before
> the egg.

Yes, that's why I bothered installing the version 2.5.x of the intel
driver, which is supposed to have such support.

Anyway, I just realized that Ubuntu does not turn on the option that
according to git you added to the driver to disable KMS by default.
Duh :(
