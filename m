Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZLUWEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZLUWEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbZLUWEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:04:36 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:47159 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbZLUWEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AsMwlxGDtUgglgEjb07G7eLC4IEjUeAfe8ba/8EV4WKuI2EqAhYwlx66K54hXeYjQU
         EDIryi0WNC26DIuS102FcRbAKt+E0k7O6hyO6pUzKMgVut79faHGDEf1zlY17Z30t3jj
         N4PiSFrkalEY3bBAYQghIXFgwCYh9wnA5yCDE=
MIME-Version: 1.0
In-Reply-To: <200912212247.15265.johannes.hirte@fem.tu-ilmenau.de>
References: <200912212238.54069.johannes.hirte@fem.tu-ilmenau.de>
	 <20091221214235.GA11558@nokia.com>
	 <200912212247.15265.johannes.hirte@fem.tu-ilmenau.de>
Date: Mon, 21 Dec 2009 17:04:33 -0500
Message-ID: <a728f9f90912211404y4f6a4bcay569d17eeade8add4@mail.gmail.com>
Subject: Re: [Oops:] radeon KMS in 2.6.33-rc1-00154-gf7b84a6
From: Alex Deucher <alexdeucher@gmail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: felipe.balbi@nokia.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 4:47 PM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
> Am Montag 21 Dezember 2009 22:42:36 schrieb Felipe Balbi:
>> Hi,
>>
>> On Mon, Dec 21, 2009 at 10:38:53PM +0100, ext Johannes Hirte wrote:
>> >When loading the radeon module with modeset=1, the kernel oopses:
>>
>> [snip]
>>
>> >Dec 21 21:58:14 datengrab firmware.sh[2542]: Cannot find  firmware file
>> >'radeon/R600_rlc.bin'
>>
>> does it have something to do with the missing firmware file ??
>
> Yes, I've tested with the firmware binary from
> http://people.freedesktop.org/~agd5f/radeon_ucode/ now and it works. It seems
> a fallback path is missing if no firmware is found.

It should fallback properly if no ucode is found in airlied's drm tree at least.

Alex
