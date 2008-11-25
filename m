Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbYKYIZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbYKYIZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYKYIYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:24:53 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3230 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKYIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:24:51 -0500
Message-ID: <17655.62.70.2.252.1227601475.squirrel@webmail.xs4all.nl>
Date: Tue, 25 Nov 2008 09:24:35 +0100 (CET)
Subject: Re: v4l2_device/v4l2_subdev: please review
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Cc: "v4l" <video4linux-list@redhat.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Hans,
>
>>
>> I'm not going to spam the list with these quite big patches. Just go to
>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-ng/ and click on the 'raw' link
>> after each change to see the patch. Most of these changes are just
>> boring i2c driver conversions.
>
> It is hard to review these patches from this link, as if you submit
> the patch to ML then someone can just give inline comments to your
> patch, otherwise reviewer has to copy that code which he/she wants to
> comment while replying and not easy to track too. I don't know size
> limit of this v4l2 ML, but linux-kernel ML can receive somewhat big
> patches I believe.

The V4L2 ML is fairly limited. I'm pretty sure it can't handle the ivtv
change (70+ kB). I can do this for the two changes that actually add the
new code and for one of the i2c conversion tonight (this webmail client
messes up the layout).

Personally I dislike reviewing large patches that are part of an email.
Smaller ones are OK, but large patches are hard to read. Much easier to
review with a decent editor.

>
>>
>> We are adding to the v4l core, but the changes do not affect existing
>> v4l drivers let alone other subsystems. Although I should probably have
>> added the omap list.
>
> OMAP + soc-camera + v4l2-int-* community would be more interested to
> see these patches as they need to change their sensor/controller
> drivers to adapt your changes.

I'll add the linux-omap mailinglist when I repost tonight.

Regards,

          Hans

