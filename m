Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZEDMEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZEDMEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 08:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZEDMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 08:03:59 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:58645 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZEDMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 08:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oX3htvBWiipETJt1jjF6npQqmgodJPORtjwh5TaB2h8RAOYp5waGvsilVzbbk+axh7
         TVoM3rNAKItAp2RxS1AVuMhLKg/G3yZG9F1h+ROuH0DJBOHWtuL/qg6YKexcvIJHtyOz
         +ANhvjugy9FBpuahqDiuPNAZlLfbpr18k/GFQ=
MIME-Version: 1.0
In-Reply-To: <20090504113751.GA22603@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de>
	 <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com>
	 <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com>
	 <20090504113751.GA22603@avionic-design.de>
Date: Mon, 4 May 2009 17:33:56 +0530
Message-ID: <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com>
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
From: Trilok Soni <soni.trilok@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Kwangwoo Lee <kwangwoo.lee@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, May 4, 2009 at 5:07 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> * Kwangwoo Lee wrote:
>> Hi Thierry and Trilok,
>>
>> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
>> > Hi Thierry,
>> >
>> > I have added linux-omap community. How different is this chip from
>> > tsc2007. It looks to me that this chip is not much different from
>> > tsc2007 (this is just quick look at the driver). If they
>> > are similar please consider using i2c_device_id feature in tsc2007 to
>> > accommodate this chip.
>>
>> I agree with the Trilok's opinion.
> [snip]
>
> I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
> finished (it's actually pretty old, I just never got around to submitting
> it). However I never got the tsc2007 to work on my platform because it uses
> sleeping functions inside the timer handler, which results in an oops right
> after the first touchscreen interrupt.
>
> I guess I could try and fix the tsc2007 properly instead of having a second,
> pretty similar driver in the tree.
>

This could be because of improper locking? If you share a crash we can
have look at it.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
