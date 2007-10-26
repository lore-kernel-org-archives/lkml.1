Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXJZPVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXJZPVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXJZPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:21:32 -0400
Received: from tristate.vision.ee ([194.204.30.144]:56642 "HELO mail.city.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752509AbXJZPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:21:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 11:21:30 EDT
Message-ID: <47220467.7000802@vision.ee>
Date: Fri, 26 Oct 2007 18:14:47 +0300
From: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@vision.ee>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux machines dieing in swap storms
References: <1193325641.5776.21.camel@localhost.localdomain>
In-Reply-To: <1193325641.5776.21.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems very similar to my case, where it is very easy to
completely trash the computer in 30 seconds.

Conf: core2 cpu, 2gb memory, 2gb swap, 64-bit os.
Software: latest stable xorg, firefox2, latest gnash (all from gutsy)

Go to site http://www.epl.ee/ and almost immeditately you loose
control of your computer - mouse gets very jerky, clicks aren't registered,
switching consoles doesn't work. If I'm quick enough, I can go and log
on over ssh remotely and kill all gnashes. But some moments later even
that is not possible. It just trashes hard drive.

Yes, one could set up different limits and what-so-ever ... but my point 
is -
it is tooo easy to kill your linux computer (or your friends server). 
This should
be changed.

With best,
Lenar

Richard Purdie wrote:
> I've got a problem I keep running into. My computers have buggy software
> which can sometimes run out of control. Two specific examples:
>
> Evolution: Sometimes its memory usage decides to suddenly grow out of
> control. It usually idles at around 300MB, you can watch it in top,
> doubling, trebling and ending up going past the 1200MB mark. My system
> has 1.5GB ram and you notice it swapping heavily past say 800MB.
>
> Spamassassin: If my mail server log files hit the 2GB file size limit of
> the filesystem something strange happens and for whatever reason spamd
> suddenly starts growing in memory usage until it uses up all available
> system memory.
>
> Arguably both pieces of software are buggy, I accept that, fine. 
>
> In both machines in totally different circumstances what happens next is
> bad. The systems swap more and more heavily trying to cope with these
> out of control processes. Network interactivity stops. The swap storm
> gets so bad you can't log onto the console any more. I've left machines
> in this state for 1-2 hours and they don't come back. Watching the
> console, the OOM killer does kick in but it never kills the problem
> process (both spamd and evolution are long running processes that have
> suddenly gone out of control). In then end, you have to hit the reset
> switch :(. This happened to my desktop once again about 10 minutes ago
> and its *extremely* frustrating. Sometimes I can catch and kill the
> offending process but I shouldn't have to.
>
> This isn't a new problem. My mail server used to be running an ancient
> 2.6.12 kernel and I upgraded it to 2.6.22.X in an effort to solve this
> problem which no change. My desktop shows exactly the same kind of OOM
> swap storm behaviour (2.6.20 based).
>
> I realise that tuning the OOM killer is a really tricky problem but
> something needs improving as the current user experience is broken.
>
> I'm seriously tempted to add a "kill the process using the most memory"
> key combination into SysRq which might let me save the desktop but won't
> help with my remote server. I could also just disable swap I guess.
>
> Advice on solving this welcome preferably in mainline but I'll happily
> hack my kernels with a workaround if need be.
>
> Cheers,
>
> Richard
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

