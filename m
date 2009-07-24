Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZGXGDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZGXGDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGXGDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:03:40 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:39381 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbZGXGDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:03:39 -0400
Date: Fri, 24 Jul 2009 09:03:12 +0300 (IDT)
Message-Id: <200907240603.n6O63CrO000735@indigo.cs.bgu.ac.il>
From: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: max freq is 2.1, but current freq is between min.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Organization: CS Department
X-Mailer: CS Webmail v3.10
In-Reply-To: <20090723210616.GB18811@redhat.com>
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri 24 Jul 0:06 2009 Dave Jones wrote:
> On Thu, Jul 23, 2009 at 10:36:46PM +0300, eial@cs.bgu.ac.il wrote:
>  > 
>  > I have a t8100 cpu, running gentoo, I've tried both kernels 2.6.29 and 30, but for no avail.
>  > I have 4 stepping: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz but under all governors, the max freq is 1.2 it changes here and there: cpufreq-info shows this:
>  > ..
>  >   current policy: frequency should be within 1.20 GHz and 1.20 GHz.                     <----- range is not ok
>  > ..
>  > the range keeps changing, due this thing, it took e 6 and a half hours to compile openoffice, almost twice than the average time that I have compiled it before.
>  > most of the time, the computer is unusable.I have no idea what else can be done, I've checked the bios, all ok, that is the latest version of bios, running boinc, compile and checking for broken libs keeps the freq at min...
> 
> Boot with cpufreq.debug=7 and you should see notices in your dmesg when the
> upper bound is being limited.  This usually happens when the BIOS tells us
> the system is overheating. As it cools off, the higher speeds should become
> available again.
> 
> 	Dave
> 

here is the snip: http://pastebin.ca/1505420

the temp is the same like it was in the days I had absolutely no problems. I thought it of it too but the output says differently...


