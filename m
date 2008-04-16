Return-Path: <linux-kernel-owner+w=401wt.eu-S1764983AbYDPRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764983AbYDPRUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYDPRU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:20:27 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:11031 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYDPRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=h20kWmdMI8SIXa4v4IWhJCEX8wA2gLuRrmnIuJIK5otjoRheNM2IhNlmbINcZkHaFhAoBYZ3IBYefu5ldkHfw9+X5cIwwv464YcfJMn7HNx4iRRPm7tyAdu2pXtKqzlP9XoAJN9aOnn8QxPHiEeauzRYve2jIcW7It0Q4ciP9nA=
Message-ID: <1f1b08da0804161020x7335e58qae9a237da83cb93b@mail.gmail.com>
Date: Wed, 16 Apr 2008 10:20:25 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: Roland <devzero@web.de>
Subject: Re: Clock has stopped (time/date looping over 5 secon
Cc: rogerheflin@gmail.com, joel.greene@catapult.com,
       linux-kernel@vger.kernel.org, pavel@ucw.cz
In-Reply-To: <007901c899c2$1df6ae30$6400a8c0@bui.materna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <007901c899c2$1df6ae30$6400a8c0@bui.materna.com>
X-Google-Sender-Auth: aaf2ee97fd6f10eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 2:47 PM, Roland <devzero@web.de> wrote:
> > It _appears_ that there is a race in the kernel that can be triggered by
> > any number of hardware issues. There's another thread by Gregory Stark
> > with the same symptoms - he thinks his was fixed by replacing a bad
> > DIMM.
> >
>
>  i`d like to mention that we may have a repro-case (if it`s the same issue i
> hit within vmware):
>
>  see http://communities.vmware.com/message/909403

The looping ~5seconds sounds like nanosecond overflows. Might it be
that vmware isn't delivering timer interrupts? Could this be an
interaction w/ hrt or no_hz?

thanks
-john
