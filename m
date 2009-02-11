Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZBKXGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZBKXGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZBKXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:06:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:10701 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZBKXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:06:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x9CSxSrFXvrvZT1EATKDrTQFiUbesNcqeI1/xNv4jsoR2lhr8GNI4R0AqAe8ZWQmUu
         hKfeXLM+OcRVEcDydl7RMcolZCpvnIfaySrmPsB3Q/pakm/DZZCbi80oaT+JV3I55KYn
         as20rQipWaCUkh1mBsN2PS48+6xZGT/EzU69s=
MIME-Version: 1.0
In-Reply-To: <20090211145355.7b3d060d.akpm@linux-foundation.org>
References: <49929EB8.4020802@tremplin-utc.net>
	 <1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <20090211143844.27ca0d6c.akpm@linux-foundation.org>
	 <cb7bb73a0902111444h46be9b65pa01d4b2b9c31afe8@mail.gmail.com>
	 <20090211145355.7b3d060d.akpm@linux-foundation.org>
Date: Thu, 12 Feb 2009 00:06:41 +0100
Message-ID: <cb7bb73a0902111506u5fca742fq985870e1b5fd8515@mail.gmail.com>
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net, pavel@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 11:53 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Feb 2009 23:44:20 +0100
> Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
>>
>> I based my patch on Linus' tree, plus Pavel's patch which I've been
>> told is on your tree.
>
> What is "Pavel's patch"?  Pavel writes lots of patches :(

Right, sorry. This one:

http://userweb.kernel.org/~akpm/mmotm/broken-out/hp-accelerometer-add-freefall-detection.patch

Thanks for the link to mmotm, btw.

I noticed that the patch check complained about the misaligned switch.
Do you want me to resend it with the shifted block? (I see from the
email that it was shifted automatically though).

-- 
Giuseppe "Oblomov" Bilotta
