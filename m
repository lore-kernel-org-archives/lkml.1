Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZIVNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZIVNIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbZIVNIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:08:17 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:34162 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbZIVNIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SaLBXxqdO5jzPhrAXYScJLTwnvwy0Hvar0rx0/z42JX1DErq2ShbddFzVSI2US9d8z
         82i0Ln/YLsrMf8a9dMhhZqz60ZFg+ztlQzuLPmnOzN9W7ehvi2zAFKs12uyxOGBWz4M6
         vZQ70MGPrEc4NQkkXlU04iXnP+9+Q4ecKDi3o=
MIME-Version: 1.0
In-Reply-To: <20090922143053.287fc8a5@vlado>
References: <ba5648fa0909212143g36f47acck2e4b610429c477ec@mail.gmail.com>
	 <20090922143053.287fc8a5@vlado>
Date: Tue, 22 Sep 2009 10:08:19 -0300
Message-ID: <2d5a2c100909220608j1600e8f2k4063d6b2ff7b3296@mail.gmail.com>
Subject: Re: BlueZ Supported Profiles
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Vladimir Botka <vbotka@gmail.com>
Cc: bluezprofile kernel <bluezprofile@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 22, 2009 at 9:30 AM, Vladimir Botka <vbotka@gmail.com> wrote:
> On Tue, 22 Sep 2009 10:13:40 +0530
> bluezprofile kernel <bluezprofile@gmail.com> wrote:
>
>> Hi,
>> I would like to know what are all profiles supported by BlueZ?
>> Is there any site gives list of profiles supported by BlueZ?
>> I am using BlueZ 4.46.
>>

BlueZ is modular, so it depends on which plugins you have enabled.
Also some profiles like a2dp and hfp depend on others components such
as PulseAudio to really work, so the answer is not that simple.
Perhaps you should ask what profiles you want so we can give a more
direct answer, in general we support most profiles used by desktops
and phones.

> Hi,
> you can see the provided services with the command:
> # sdptool browse BTADDR
>
> Get the BTADDR from the output of:
> # hcitool scan
>
> Run these command from another Linux box.

You can do the very same think locally:
# sdptool browse local


-- 
Luiz Augusto von Dentz
Engenheiro de Computação
