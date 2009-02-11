Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbZBKMhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbZBKMhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZBKMha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:37:30 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:60442 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbZBKMh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fOUDJemVcBp2fsHrIYzJuNBbUM76eP8P6RgREcfTnFJHZgzeGjK6+5tAqAw36zXNgn
         GAOtfhNJGwd7vYIcjMKnk6BAkFfMzUXKqwmTldsG8U554OEbkISn9z0ByFeXH6Nu9aYL
         PXMyYBgMAQZu0yD1kZOPmEPHlOqbBcNmQkhZU=
MIME-Version: 1.0
In-Reply-To: <cb7bb73a0902110402o58816f56qb6b7ee200ca24c2e@mail.gmail.com>
References: <200902102347.n1ANlYkI011003@imap1.linux-foundation.org>
	 <4992A7C1.7040607@tremplin-utc.net>
	 <cb7bb73a0902110402o58816f56qb6b7ee200ca24c2e@mail.gmail.com>
Date: Wed, 11 Feb 2009 13:37:26 +0100
Message-ID: <cb7bb73a0902110437i230ed992s4d01b802473be2d6@mail.gmail.com>
Subject: Re: lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch 
	removed from -mm tree
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: akpm@linux-foundation.org, palatis@gmail.com, pavel@suse.cz,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 1:02 PM, Giuseppe Bilotta
<giuseppe.bilotta@gmail.com> wrote:
> On Wed, Feb 11, 2009 at 11:26 AM, Éric Piel <eric.piel@tremplin-utc.net> wrote:
>> Palatis, if you could try this patch plus the patch "lis3lv02d: support
>> both one- and two-byte sensors" to confirm it does the right thing also
>> with your laptop, it would be great. Unfortunately, right now I think
>> they apply only on top of the -mm tree...
>
> It's possible to apply them on top of Linus' tree modulo Pavel's
> "don't touch init" patch.
>
> However, I think my patch might not be good for Palatis. If the
> dmidecode that was posted some time earlier was his (don't recall
> right now) I remember it being an AMD board, whereas I'm on an Intel
> board, so we have different dv5 models and we probably need different
> fixes, so I need to work out a better patch, but I'll need Palatis'
> help testing it.

I took the liberty to publish my changes over at
http://git.oblomov.eu/linux-2.6/oblomov : the topmost commits of this
branch are (1) Pavel's no-init, (2) my one- and two-byte sensors
support (3) an attempt at supporting both intel and amd hpdv5.
Palatis, can you wget

http://git.oblomov.eu/linux-2.6/patches/1db8508cf483dc1ecf66141f90a7c03659d69512..oblomov

git am it, remake the hp_accel and lis3lv02d modules, and see if you
get proper directions for your laptop? If not, can you post your
dmidecode and the results of testing axis orientation without the last
patch?

-- 
Giuseppe "Oblomov" Bilotta
