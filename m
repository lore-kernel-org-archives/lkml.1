Return-Path: <linux-kernel-owner+w=401wt.eu-S1031368AbXFHSX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031368AbXFHSX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937330AbXFHSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:23:46 -0400
Received: from smtp1.netcabo.pt ([212.113.174.28]:53360 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937242AbXFHSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:23:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkchANo7aUZZmGIhQWdsb2JhbACBTo4WAQEBPQ
Message-ID: <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>
In-Reply-To: <1181317625.4404.332.camel@chaos>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> 
    <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu> 
    <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos> 
    <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>
    <1181317625.4404.332.camel@chaos>
Date: Fri, 8 Jun 2007 19:21:37 +0100 (WEST)
Subject: Re: 2.6.21-rt2..8 troubles
From: "Rui Nuno Capela" <rncbc@rncbc.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 08 Jun 2007 18:23:42.0424 (UTC) FILETIME=[24987D80:01C7A9FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, June 8, 2007 16:47, Thomas Gleixner wrote:
> On Wed, 2007-06-06 at 01:44 +0100, Rui Nuno Capela wrote:
>
>> Just for the heads-up, I'm still suffering from this same illness, and
>> it seems even worse (big freeze happens earlier) on 2.6.21.3-rt9.
>>
>> There's no way around. On one box it works flawlessly (desktop,
>> P4@3.3Ghz) while on the patient one (laptop, core2 T7200) it bricks
>> silently.
>
> Sorry for responding late. To have some idea where the breakage comes
> from, can you please try
>
> http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt5.pat
> ch
>
> whether it has the same behaviour.
>

Just built from linux-2.6.22-rc4.tar.bz2, with patch-2.6.22-rc4-hrt5.
All's working apparentely nice on this offending machine (laptop, intel
core2 T7200). In fact, I'm writing this very reply under it and through
ipw3945 wifi module--which never was so pragmatic on -rt2..9 ;)

Nevertheless, this is not preempt-realtime (-rt) is it? And I it never
complained about vanilla.

Is this good news though?
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
