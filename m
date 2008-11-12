Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYKLUuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYKLUuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYKLUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:49:58 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:61328 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYKLUt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YBf/o5HGBDB5bLihHCHr5jgDPdWgXCpuHKaTY65RZ/5kKSB4l8el2ybzjp4YJPbOIH
         Scj3gdnJ74t3Q1zjcC0BRm6otfewoujykfV+6hbC7xFoElhEMcKghx+BP54ue6Ud6n4e
         7DVzFBiPhzdYU/zF0v8rjO7SAQYQ0O1Nwp8/A=
Message-ID: <67f22cb80811121249n300177c8l26a57aaf0030120b@mail.gmail.com>
Date: Wed, 12 Nov 2008 14:49:56 -0600
From: "Rob Latham" <rlatham@gmail.com>
To: "Nico -telmich- Schottelius" <nico-linux-next@schottelius.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3(-next20081103) suspend issues on Lenovo X200
In-Reply-To: <20081105173132.GA4289@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081103153945.GA20618@denkbrett.schottelius.org>
	 <200811040155.59933.rjw@sisk.pl>
	 <200811031704.25717.jbarnes@virtuousgeek.org>
	 <20081105173132.GA4289@denkbrett.schottelius.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 11:31 AM, Nico -telmich- Schottelius
<nico-linux-next@schottelius.org> wrote:
> When running xorg the system freezes on wakeup and hard reboots after
> 20 seconds (again: looks like some kind of watchdog, though I am not
> aware of anything like that in the X200).
>
> Sincerly,
>
> Nico (again: looks like some kind of watchdog, though I am not
> aware of anything like that in the X200).

Hi Nico, all.

I've had good results disabling one core before suspending, and then
enabling the extra core after wakeup.   The watchdog in that case
might not be the intel driver at all, but rather something in the
kernel that kicks in in such conditions?

http://ubuntuforums.org/showpost.php?p=6105510&postcount=12

(I put the "sleep before enabling 2nd core" in the background and for
a longer period of time)

Suspending/resuming in this single-core mode has worked really well
for me for the last day or so.

Hope that helps  point to the root cause...
==rob
