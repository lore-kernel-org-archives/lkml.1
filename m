Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZGEKTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZGEKTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZGEKS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:18:57 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:40937 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZGEKS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ly57ZABUih+STfzRHqxlMniMN5z0+uxLxEyqEmpbNPC5Bp6imRTUEe70RMo2zagOe2
         dgtXVhzD+S8CTUgqb4EbOnqrS3Ymd8PRMICvPmPbIxjiGhdCLJZvOZ52B37UbuSdqtmi
         F1gcCXrmxegpnluiR27xBiZfIukXFNcY9AKbU=
MIME-Version: 1.0
In-Reply-To: <20090701091255.363f9d4d@jbarnes-g45>
References: <1246458059-15965-1-git-send-email-apw@canonical.com>
	 <20090701091255.363f9d4d@jbarnes-g45>
Date: Sun, 5 Jul 2009 07:18:59 -0300
Message-ID: <ce0170d90907050318q18dab776x2fc3b4f516292e89@mail.gmail.com>
Subject: Re: [PATCH 1/1] i915: fix up a raw 64bit divide
From: Sergio Luis <eeeesti@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andy Whitcroft <apw@canonical.com>, Dave Airlie <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 1:12 PM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> On Wed,  1 Jul 2009 15:20:59 +0100
> Andy Whitcroft <apw@canonical.com> wrote:
>
>> We are seeing compilation failures on i386 in some environments due
>> to an undefined reference as below:
>>
>>     ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!
>>
>> This is generated due to a raw 64 bit divide in the i915 driver.  Fix
>> up this raw divide.
>>
>> Signed-off-by: Andy Whitcroft <apw@canonical.com>
>
> I think building with newer GCCs will prevent this error, but the fix
> looks fine.

I get it in here (31-rc2), with gcc 4.2.4, but only if I have
CONFIG_DEBUG_SECTION_MISMATCH=y. With this patch it works regardless
of that option.

>
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> --
> Jesse Barnes, Intel Open Source Technology Center
> --
