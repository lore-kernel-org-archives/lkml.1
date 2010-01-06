Return-Path: <linux-kernel-owner+w=401wt.eu-S932504Ab0AFRoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0AFRoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410Ab0AFRoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:44:34 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:54591 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0AFRod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pkut1bliRmBiom4Qiyjltls8pQ3wx4ToAylwaAVLDUkie/I/bh1/pLtXT5ezVFDp9C
         4qVi/mVLsMpXxqzBIzqmQZUxgML+QVJRBdOXCTsZps27GkKXs+B+WgryFeOIDQQ0BFjT
         1Xcf2WW6ZUpHDJ0pJU0Btb79IwBPlWSwAmr9Y=
MIME-Version: 1.0
In-Reply-To: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Jan 2010 09:44:13 -0800
Message-ID: <43e72e891001060944k28fdfaa7rb5d2325bc5399e6e@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: wireless, fix lock imbalance
To: Jiri Slaby <jslaby@suse.cz>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 8:35 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
> Fix that.
>
> Trigerrable by "Scan for SSID" with long enough SSID (> 32).

Cc stable as well?

  Luis
