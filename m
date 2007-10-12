Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXJLW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXJLW3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXJLWTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:21494 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbXJLWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XCkgfZ/UIMsgRapDwuw3jJ9N3dTwFq6qRZ0UQtMzgPSUAU6W4BRkID7vX3xlbbYCiYjWPE+qt6E2jryfFhdTSE8JpsWT4o/IoxDGXdB2G6y6aGgb8AuvYjMGKjmePqJJQPZLLHsgl4ZJ1nRJYskiW6QlksuNZyB3fYNp+VeeD5g=
Message-ID: <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>
Date: Fri, 12 Oct 2007 17:19:03 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: hdparm standby timeout not working for WD raptors?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <470F7705.3@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
	 <470E7B90.5060203@rtr.ca>
	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
	 <470F7705.3@rtr.ca>
X-Google-Sender-Auth: 4d573d65a6fb160f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Mark Lord <lkml@rtr.ca> wrote:
>
> That's interesting.
>
> So, either something is regularly accessing/polling the drive,
> or it just doesn't work with the standby timer.
>
> Are there any interesting kernel messages being generated
> during execution of those commands?

No messages to /var/log/messages as a result of those
commands; I ran several times and did a sync too, just
in case.

I very much doubt that something is regularly accessing
the drives because I have a script that runs every 1/2 hour
to check and log status. The drives stay "standby" for
hours (even days) at a time unless I specifically access
something on the RAID array. Then, they stay "active/idle"
until I manually set them to "standby".

Anything else you'd like me to try?
