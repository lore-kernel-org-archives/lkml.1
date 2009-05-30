Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbZE3LpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbZE3LpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZE3LpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:45:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:41276 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbZE3LpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TlOfp/U3sTewFRigCWIxl1TLy+hR+pWzcyusp03kP4ml0mvveNLoDOPjJt6d1rQD1I
         uArPRjFHf2K9R64KtX5+Pm3IN+Zlr3m3zx2VaDlVALQhh9wTdEo0l9wa3j2ZySz7vpSB
         2NzeC1LKfhOr2WjevFx5D64B0Uorn2fowebic=
MIME-Version: 1.0
In-Reply-To: <4A210C3F.1070408@f2s.com>
References: <1243279681-4233-1-git-send-email-philipp.zabel@gmail.com>
	 <1243279681-4233-3-git-send-email-philipp.zabel@gmail.com>
	 <74d0deb30905261316hd100bbdr96e5e544eed94c2e@mail.gmail.com>
	 <4A210C3F.1070408@f2s.com>
Date: Sat, 30 May 2009 13:45:06 +0200
Message-ID: <74d0deb30905300445h9147a91k149ca5311bc23d1b@mail.gmail.com>
Subject: Re: [PATCH 2/5] mmc: tmio_mmc: add bus_shift support
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: ian@mnementh.co.uk
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 12:36 PM, Ian molton <spyro@f2s.com> wrote:
> pHilipp Zabel wrote:
>>
>> On Mon, May 25, 2009 at 9:27 PM, Philipp Zabel <philipp.zabel@gmail.com>
>> wrote:
>>>
>>> Some ASIC3 devices in the wild are connected with the address bus shifted
>>> by one line, so that its 16-bit registers appear 32-bit aligned in host
>>> memory space.
>>
>> This patch has to be amended:
>
> I have to assume that this works - I have no asic3 hardware, and bus shift
> is zero on TMIO hardware, so this didnt cause issues.
>
> This modification acked too.

Thanks. Actually, I only have bus_shift = 0 hardware, too (hx4700 and
blueangel).

According to http://wiki.xda-developers.com/index.php?pagename=ASIC3,
himalaya and the iPAQs h4xxx, h19xx, h39xx and rx37xx have the shift.

regards
Philipp
