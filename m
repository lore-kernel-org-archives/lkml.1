Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZIXIxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZIXIxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZIXIxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:53:53 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37555 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZIXIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dsmVlqscc0O3d5juhpD2M2x7G4tv1pOw6dbEnc4KVonznPVDLPilKAQLO5zerT9ytO
         +LAK1RvJD+URoS50k+8S23SLXmEFwp+BdLzLIo5TlKZODxqW+1+ONtF32WPp7fRH+gIy
         P7ZFu/Ojabns/AgMDcrgBLKdgoBQ8LscjxzZQ=
MIME-Version: 1.0
In-Reply-To: <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
Date: Thu, 24 Sep 2009 10:53:55 +0200
Message-ID: <68676e00909240153o4ae86eeegf9b6d000668ec858@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 5:18 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Wed, Sep 23, 2009 at 1:12 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
>> making the driver unable to read the data from the sensors.
>> Change the driver to use dynamic buffers (allocated by ACPI core); the
>> return value is cached, so the number of memory allocations is very low.
>>
>> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
>> Tested-by: Robert Hancock <hancockrwd@gmail.com>
>
> I just noticed a problem (either with this patch or some other issue
> with the driver on this board): The readings don't seem to be
> updating, I get the same values all the time.

Jean just relayed me some information from Asus on this board, the EC
is disabled by default.
I'm working on a fix.

L
