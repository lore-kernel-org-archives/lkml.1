Return-Path: <linux-kernel-owner+w=401wt.eu-S966884AbYCSWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966884AbYCSWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936890AbYCSVR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:17:28 -0400
Received: from mail.uport.ru ([212.220.127.245]:39528 "EHLO u-start.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936882AbYCSVR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:17:27 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 17:17:26 EDT
Message-ID: <47E09F53.5020201@permonline.ru>
Date: Wed, 19 Mar 2008 10:06:27 +0500
From: "Artem S. Tashkinov" <birdie@permonline.ru>
User-Agent: Thunderbird 3.0a1pre (X11/2008031803)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: GIT commit description flag(s)
References: <47DC4104.1070109@permonline.ru> <alpine.LNX.1.00.0803181757020.8851@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.00.0803181757020.8851@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I quite agree with you that the description is already there, but such 
flags could help easily review or grep commits in order to identify your 
areas of interest.

Even your example has ambiguity: "Wire up new timerfd syscalls" - It's 
not easy to understand whether this particular commit is a bugfix, or it 
speeds up things, or the old code which has been cleaned up, etc.

Jan Engelhardt wrote:
>
> On Mar 16 2008 02:35, Artem S. Tashkinov wrote:
>> It would be nice if [kernel] git commits had a flag [a char] (or a
>> combination of) describing their main purpose which could be the
>> following:
>>
>> bug Fix [F]
>> Speed up/Performance [S]
>> Revert [R]
>> New functionality [N]
>
> Usually you already give the type implicitly in the commit:
>
> dfd347f... HID: fix comment in hid_input_report()
> fa331ff... [S390] sclp_vt220: speed up console output for interactive work
> d9452e9... [NETPOLL]: Revert two bogus cleanups that broke netconsole.
> 8727e28... m68k{,nommu}: Wire up new timerfd syscalls
> b863ceb... [NET]: Add macvlan driver
>
> So all is well.
>
