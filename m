Return-Path: <linux-kernel-owner+w=401wt.eu-S965502AbXCGUB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbXCGUB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965516AbXCGUB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:01:58 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:40759 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502AbXCGUB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eS2afE0ebvFwctYOQZgazY/BR5+LJyq/fOYuSy9WjoD6hvt61leot/Js6KWKaE0UtFVJmYtsqkhRx668xX4sJbz5w21dHGhgOnABVyfcz0NppIqLy0lBsJV5290VVOR/4oik21U7DJKz5MIfQsT0JiGnVkvzj6pU4m/IWldAXks=
Message-ID: <75b66ecd0703071201t1bf6ff06q8a02163a6715ee56@mail.gmail.com>
Date: Wed, 7 Mar 2007 15:01:53 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [2.6.22 patch] the scheduled removal of OBSOLETE_OSS options
Cc: "Adrian Bunk" <bunk@stusta.de>, "Bill Davidsen" <davidsen@tmr.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070307062157.GJ943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070305014956.GE3441@stusta.de> <45EDA8EE.1060308@tmr.com>
	 <20070306175504.GW3441@stusta.de> <20070307062157.GJ943@1wt.eu>
X-Google-Sender-Auth: 1e0cd0bdb988dd1f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Willy Tarreau <w@1wt.eu> wrote:
> Real problem is that we can expect several "sound does not work anymore"
> because people doing "make oldconfig" will get no warning at all about
> the removed options. Remember people complaining about keyboard not working ?
> Perhaps the real problem is more Kconfig than OSS, but it would be fine if
> we found a solution to enumerate the list of options which have been removed
> when they do their make oldconfig.

I doubt there are that many users of the old OSS drivers.  Even
proprietary apps like Flash and Skype require ALSA these days.

Lee
