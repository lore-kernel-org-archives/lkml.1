Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0BTJ0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:26:18 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:44462 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0BTJ0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q3rIbMMJKlt6/edbrh8UjQYRH/euxOrcCwA+cn7j3QNr9OoqnuN6+x5qqAeVRZ+C1n
         XpmZzi4GFXtCFZbZvIIPbOSg538NbaY7qEcHksdtI1JpcZuMV8b7Q035/d188lvL984Q
         TNz2C9X4IpEE7u8ADyM7uGcEeFeTOmBmv1IzQ=
MIME-Version: 1.0
In-Reply-To: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
Date: Sat, 20 Feb 2010 17:26:15 +0800
Message-ID: <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
Subject: Re: sysfs lockdep complaint
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 5:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Get this when powernowd starts on my G5:
>
> [   30.490674] =============================================
> [   30.490708] [ INFO: possible recursive locking detected ]
> [   30.490727] 2.6.33-rc8-wl-64012-g6917413 #160
> [   30.490744] ---------------------------------------------
> [   30.490763] powernowd/2577 is trying to acquire lock:
> [   30.490782]  (s_active){++++.+}, at: [<c0000000001efa94>] .sysfs_addrm_finish+0x58/0xc0
> [   30.490831]
> [   30.490833] but task is already holding lock:
> [   30.490854]  (s_active){++++.+}, at: [<c0000000001eff80>] .sysfs_get_active_two+0x3c/0x84
> [   30.490895]

This should be fixed by the patchset from Eric:

http://lkml.org/lkml/2010/2/11/334
