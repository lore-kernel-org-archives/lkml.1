Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYFDOif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYFDOif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFDOi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:38:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:61364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbYFDOi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SMjbLFq3gST+EYv3ye6mF849n5tKjaZExkkuwikHbe3zEaqlrs6ORFS6MysqL0bs9n
         7v/9/TJHxVJs4/7OCxh/oM75o+HKpWeFNYCU8CQSaL4pE73n6xuP6nhDEGax5GyUvb67
         REwUggZ+0VbKNd0L9TC0TiuArbrVBKDf4774M=
Message-ID: <e2e108260806040738y4ad06f22tddd15df71a0a6bbb@mail.gmail.com>
Date: Wed, 4 Jun 2008 16:38:24 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: Lkm <lkm@lea-linux.com>
Subject: Re: PROBLEM: Hardware clock instable
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806041622.49593.lkm@lea-linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200806041402.39515.lkm@lea-linux.com>
	 <200806041517.43347.lkm@lea-linux.com>
	 <e2e108260806040640k3ffb9712j443c2da37feb394c@mail.gmail.com>
	 <200806041622.49593.lkm@lea-linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 4:22 PM, Lkm <lkm@lea-linux.com> wrote:
> Le Wednesday 04 June 2008 15:40:49 Bart Van AsscI de, vous avez écrit :
>> The reason I asked for the ntpd logs is that I'm still not sure
>> whether there is a hardware problem.
>
> In fact i'm wondering too .... But we have so many server with the same
> problem...
...
> 26 Feb 11:25:12 ntpd[2422]: time reset -0.492486 s
> I Don't know if we have rebooted the server this day..

A "time reset" can happen for one of three reasons:
* as a startup phenomenon (ntpd's frequency estimate is still converging).
* because of a step in the reference clock.
* because of instability of the hardware clock. Personally I have not
yet seen this.

>> And can you also post the
>> output of ntpq -pn ?
>>
> ntpq -pn
>     remote           refid      st t when poll reach   delay   offset  jitter
> ==============================================================================
> +192.168.0.150   195.220.194.193  3 u  531 1024  377    1.398    0.606   0.402
> *192.168.0.151   194.2.0.28       3 u  399 1024  377    0.554    0.426   0.172

This data looks normal -- both time servers have the same stratum,
reachability == 0377, delay and offset are below 5ms, and jitter is
below 1ms.

So I suggest that you observe the ntp logs for a few days and check
whether the ntp daemon logs any error messages.

Bart.
