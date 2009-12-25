Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZLYJqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZLYJqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZLYJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:46:14 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50226 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZLYJqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SEPvc+t8aoYy4eDu9pRRmG9i/Y6um8Am268Zu8M9FFpa1VLyKAiAD9Kj+GFQ4l49cm
         lBQObCDVflDFdPYUPZKOQZtmpK96egSnXX7jLfdPn6TTmZPXksIMcwqhS9TJj0ZAV6Rj
         pWmptl52dk2o2+zc/uDB2aD00hD6N6NJIbnLY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912250124410.11466@x200s>
References: <alpine.LFD.2.00.0912250124410.11466@x200s>
Date: Fri, 25 Dec 2009 19:46:12 +1000
Message-ID: <21d7e9970912250146s3e36cb9vcfc12a42445b37a2@mail.gmail.com>
Subject: Re: drm/radeon/kms regression: 2.6.33-rc2 does not boot
From: Dave Airlie <airlied@gmail.com>
To: Andrei Gaponenko <andrei.gaponenko@cern.ch>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 7:31 PM, Andrei Gaponenko
<andrei.gaponenko@cern.ch> wrote:
> Hello,
>
> One of my systems works fine with 2.6.32, but hangs when trying to
> boot 2.6.33-rc2.  Git bisect says
> 7923c615b811945a9d9f456c92a7a32c34167458 is the first bad commit:
>
>    drm/radeon/kms: make sure mc is initialized before mapping blit bo
>
>    We need to make sure the the MC is intialized before we map the
>    blit shader object on r6xx+.
>
> (So the problem was already present in -rc1.)
>
> The last message I see during a 2.6.33-rc2 boot is about attaching a
> disk.  Then everything stops until I press Ctrl-Alt-Del.  With a
> working kernel, the next thing would be switching the console to a
> higher resolution mode.  The graphics card is
>
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV710 [Radeon HD 4350]
>
> Please Cc me directly on replies.

Can you wait for a minute or so and see if it continues? though this sounds like
something different than others have seen.

Dave.
