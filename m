Return-Path: <linux-kernel-owner+w=401wt.eu-S967584AbXEHBEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967584AbXEHBEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 21:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967542AbXEHBEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 21:04:12 -0400
Received: from dpc691978010.direcpc.com ([69.19.78.10]:34867 "EHLO
	third-harmonic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbXEHBEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 21:04:07 -0400
X-Greylist: delayed 2756 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 21:03:53 EDT
Message-ID: <463FC24C.309@third-harmonic.com>
Date: Mon, 07 May 2007 20:20:28 -0400
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Tim Bird <tim.bird@am.sony.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, dirk.behme@googlemail.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: Need help debugging RT-preempt patch
References: <463F7449.2020509@am.sony.com>	 <1178569719.3164.6.camel@imap.mvista.com>  <463F93FB.1000908@am.sony.com> <1178572299.3164.14.camel@imap.mvista.com>
In-Reply-To: <1178572299.3164.14.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

> I'm not sure I'd get into "bisecting" one big patch. Especially if you
> new to the patches inner workings.. 
> 
> You can bisect by kernel version using the older patches but it's
> clearly limited,
> 
> http://people.redhat.com/mingo/realtime-preempt/older/

Actually working on this more closely over a year or so ago I
found a binary chop among patch versions to often be the
fastest means of locating the source of breakage.  Though that
may have been more applicable when several patch versions per
day were being generated.

-john

-- 
john.cooper@third-harmonic.com
