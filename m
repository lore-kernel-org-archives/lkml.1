Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYG3G7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYG3G7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYG3G7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:59:38 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:9262 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYG3G7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dj8P9AtW9RtR2lr8FmNBaK7fDh6Z9EOP1N871DtPuXABLukB7/XccGXBqIRGs/fW5b
         LzNVztJJWLdFZS6PDvsekk6Q2XEFuXgZ5kg8Q2/O7blUKIPY19Y+MyGsWL/Zi4chPnv3
         p8lMGLjiwoVw9FIHdn7zVErqSMqpTfDMUvejA=
Message-ID: <dd18b0c30807292359s4b41c3b1m82ddf7707f41e402@mail.gmail.com>
Date: Tue, 29 Jul 2008 23:59:34 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
Subject: Re: 2.6.26 DVD playing regression with libata
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <200807300757.29520.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807292323.28033.tvrtko@ursulin.net>
	 <20080730002011.21947c32@lxorguk.ukuu.org.uk>
	 <200807300757.29520.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 11:57 PM, Tvrtko A. Ursulin <tvrtko@ursulin.net> wrote:
> On Wednesday 30 July 2008 00:20:11 Alan Cox wrote:
>> > Jul 29 21:10:03 media kernel: [353032.319013] sr 2:0:0:0: [sr0] unaligned
>> > transfer Jul 29 21:10:03 media kernel: [353032.319013] sr 2:0:0:0: [sr0]
>> > unaligned transfer
>>
>> This is coming from the scsi/block layer and definitely isn't good.
>> Doesn't directly look like a libata bug but seems to be higher up the
>> stack. What software is triggering this ?
>
> I tried to reproduce it now but could not.
>
> After a fresh boot into 2.6.26, I first tried mounting the DVD which was fine. Then I ran lsdvd which also worked and finally mplayer without any problems. In
> contrast to that yesterday I ran my playdvd.pl (http://www.ursulin.net/2008/06/effectively-using-mplayer-within-mythtv/) script from within MythTV and it
> exited immediately. It looked like either it triggered that failure without any delay or subsystem was already in that failure mode by simple DVD insertion.
> When ran directly lsdvd would exit being unable to open /dev/dvd (/dev/scdo). Unfortunately I didn't debug it further at the time.
>
> The only difference is that yesterday box had an uptime of couple of days while this morning it was completely fresh. Unless mounting the disc before
> everything else somehow stabilised something. Hm let me do another reboot... no, still can't reproduce it.
>
> One interesting thing, sometimes it detects drive capabilities like this:
> [    3.498951] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
>
> And sometimes like this:
> [    3.514104] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
>
> Later I think is correct according to drive datasheet.
>
> I will keep 2.6.26 running and see if the problem comes back in following days.
>
> Tvrtko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I usually see these errors with mplayer i.g. insert a dvd
then press play instead of waiting for the dvd to settle down.

-- 
Justin P. Mattock
