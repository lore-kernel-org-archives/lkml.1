Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZLDHmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZLDHmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZLDHmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:42:53 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61573 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbZLDHmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dReBf1L139rfvYn0vV8C57fFlCXZGPI662ywVLTHlUJDMKoasCsi1CSbG1Jzwpr9VE
         pjmCVb799CKNKsFuFgxGb9wYnKK5EuqIJmOoxBe34TO7cwTjshcYc/rp2xID6T0s67ku
         hME/KEQ24mXi/v2Y8ZXGrAC/CgxkhlbKVkuGA=
MIME-Version: 1.0
In-Reply-To: <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com>
	 <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com>
Date: Fri, 4 Dec 2009 16:42:58 +0900
Message-ID: <aec7e5c30912032342h1c5b6128jbc28adccc86e5e38@mail.gmail.com>
Subject: Re: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set 
	VM_IO flag.
From: Magnus Damm <magnus.damm@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org,
       armbru@redhat.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 12:31 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
> vmalloc. Setting VM_IO is not necessary as the memory obtained
> from vmalloc is System RAM type and is not susceptible to PCI memory
> constraints.
> ---
>  drivers/video/fb_defio.c |    4 +++-
>  include/linux/fb.h       |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)

I just tested this on a Migo-R board which is using sh_mobile_lcdcfb.c
in deferred io mode. No problem.

Tested-by: Magnus Damm <damm@opensource.se>

/ magnus
