Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZEZTvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZEZTvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZEZTv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:51:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:44406 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbZEZTv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PJIz8bwXslMXjzL8DxzmMcLb8h5qFjm0gvRk2zcsCzdyFiO6CmFFoPPCMkStlEdWNS
         NVe+vX1lE13BzpXfi0OVO1ot+/DSODVaJOoIOTYjxIQKyigMnH09oBqTFR11JG5kgSq4
         j6rzwZWKiJPnILasUGuFJQsj9p4if7rn/qBQs=
MIME-Version: 1.0
In-Reply-To: <3d2f29dc0905241853h594aa2a9ta21dee45979c567e@mail.gmail.com>
References: <3d2f29dc0905180125x5e7ef51dqf10955a3d44336e2@mail.gmail.com>
	 <200905242236.22715.rjw@sisk.pl> <4A19BA09.4050502@zytor.com>
	 <20090525011819.GA9805@sli10-desk.sh.intel.com>
	 <3d2f29dc0905241853h594aa2a9ta21dee45979c567e@mail.gmail.com>
Date: Tue, 26 May 2009 15:51:28 -0400
Message-ID: <3d2f29dc0905261251h701aeb03w3ec6269b04d5e333@mail.gmail.com>
Subject: Re: Boot problems with 2.6.29.1 - cannot smoothly boot on battery
From: Chris Howie <cdhowie@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 24, 2009 at 9:53 PM, Chris Howie <cdhowie@gmail.com> wrote:
> On Sun, May 24, 2009 at 9:18 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> if this is a AMD CPU, please check http://bugzilla.kernel.org/show_bug.cgi?id=13233
>
> Ahh, that sounds like it.  I first noticed the problem in 2.6.28 after
> switching from 2.6.26 (but never tried 2.6.27).  So the information
> about versions is indeed consistent.  I'm on an amd64 cpu.
>
> Thanks everyone for the suggestions, I will try to take a look within
> the next couple of days and report my findings.

The bug linked was in fact my problem, and after forward-porting the
patch to 2.6.29.4 (which required manual patching for one hunk --
luckily this was straightforward) my system boots perfectly on battery
and AC.

Many thanks all, this was the only issue I've had with the latest
kernels.  I'm very happy that it's out of the way!

Cheers,
-- 
Chris Howie
http://www.chrishowie.com
http://en.wikipedia.org/wiki/User:Crazycomputers
