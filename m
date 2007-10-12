Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXJLFIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXJLFIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXJLFH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:07:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:61448 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXJLFHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Yo8ZcrycuKIwVoox1DB57iSdPRmHjNjlf2iiHjhyZvlRw3hCpA9Gm7SmzLNTYGg9S+HXvuJ6MQqvDbIAeU5WxPnmSgX/K560RsNvH4b2hAVYJlobZnKgIaUS5JduaZ2TpPK9i0P6lJJUAHB47UtxyulEgFv4Kg6sM9NbO2MlKok=
Message-ID: <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>
Date: Fri, 12 Oct 2007 00:07:54 -0500
From: "Mark Weber" <crash@treysoft.com>
Reply-To: crash@treysoft.com
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: hdparm standby timeout not working for WD raptors?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <470E7B90.5060203@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>
	 <470E7B90.5060203@rtr.ca>
X-Google-Sender-Auth: 66a462aab6615acf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Mark Lord <lkml@rtr.ca> wrote:
>
> What do you get when you try this:
> hdparm -S1 -C /dev/sda;sleep 6; hdparm -C /dev/sda
> ??

Thanks for taking an interest.

I ran the commands and  got the result shown
below. Anything else you want me to try?


# hdparm -S1 -C /dev/sda; sleep 6; hdparm -C /dev/sda

/dev/sda:
 setting standby to 1 (5 seconds)
 drive state is:  active/idle

/dev/sda:
 drive state is:  active/idle


Should I give sdparm a shot?
