Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYLEVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYLEVk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYLEVkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:40:16 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:40472 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYLEVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hdv+38Zicb+z4KD8AwD8IYCsyArsDBaSg3ng5VuK6+qIFjMKk2XaEeK1QTDJZxIKbi
         h+FvdYW2onyhY5lJ1NCfavfz+CD+utWXrlQr59rSyY0D7/txm+4WR44bduyc/447ezd8
         FOjKWWQkY44rL9eVyb3QGq1oB63wOetAWa7gc=
Message-ID: <1f1b08da0812051340t1967e753h354346d13ccb34d3@mail.gmail.com>
Date: Fri, 5 Dec 2008 13:40:13 -0800
From: "john stultz" <johnstul@us.ibm.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
Cc: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <49358017.7080009@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49358017.7080009@t-online.de>
X-Google-Sender-Auth: 39910fadd4e3b651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 10:36 AM, Harald Dunkel
<harald.dunkel@t-online.de> wrote:
> Hi folks,
>
> If I build a kernel for AMD Geode, then I see a clock drift of appr.
> 30 min. to 1 hour per day. If I build the same kernel for i486, then
> the clock drift is gone. Running ntp makes no difference.

For both configs, can you run:
   cat /sys/devices/system/clocksource/clocksource0/available_clocksource
and:
   cat /sys/devices/system/clocksource/clocksource0/current_clocksource

Then send back the output?

thanks
-john
