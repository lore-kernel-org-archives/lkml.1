Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXCQRGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXCQRGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXCQRGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:06:25 -0400
Received: from static-195-162-201-231.customer.tvd.be ([195.162.201.231]:47172
	"EHLO postino.comnet.be" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXCQRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:06:24 -0400
Message-ID: <39605.87.244.133.121.1174151177.squirrel@postino>
In-Reply-To: <63140.87.244.133.121.1174080814.squirrel@postino>
References: <63140.87.244.133.121.1174080814.squirrel@postino>
Date: Sat, 17 Mar 2007 18:06:17 +0100 (CET)
Subject: Re: New kernel mouse recognition problem
From: "Victor Fernandes" <Victor.Fernandes@comnet.be>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thanks for you feedback, sorry for the delay on my reply but because
I'm not subscribe to the list, only now I saw your message. I hope you
will be able to see that this message is a follow up on the previous ones.
If you do not mind can you please Cc directly to me.

Now to answer your questions.
The mouse do not works properly, I mean with this that I have the mouse
pointer on the screen, with gpm and X, but it jumps randomly when used.

I include below the output from the cat /proc/bus/input/devices, on my
actual kernel, 2.6.17-5, I can not include the one from the previous
kernel because I've reinstalled the system and I don't have at the moment
the possibility to run that previous kernel on the system. If necessary I
can try to install it again.

If you prefer that I subscribe to the list to make you followup's easyer
just let me know.

Thanks

Victor Fernandes
Output from cat /proc/bus/input/devices:
I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input0
H: Handlers=kbd event0
B: EV=120013
B: KEY=4 2000000 2b803878 f840d001 f2ffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0011 Vendor=0002 Product=0001 Version=0000
N: Name="PS/2 Logitech Mouse"
P: Phys=isa0060/serio2/input0
S: Sysfs=/class/input/input1
H: Handlers=mouse0 ts0 event1
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3



to reply
From	Dmitry Torokhov <>
Subject	Re: New kernel mouse recognition problem
Date	Fri, 16 Mar 2007 21:24:49 -0400
Digg This

Hi Victor,

On Friday 16 March 2007 17:33, Victor Fernandes wrote:
> Dear kernel gurus,
>
> I have a long experience with linux but not at the kernel level, so my
> apologies if this post is not appropriate for the list, but it seemed to
> me to be the only possible one to post my question.
>
> Obviously I've also tried to find the solution on the archives (and more)
> but found nothing appropriate.
>
> Problem: It appears that the new kernels, I've actually kernel 2.6.17-5
> (Mandriva 2007) installed, and tested others on the 2.6.x range, do not
> recognition my "Track Point" mouse anymore. I have on the boot logs
> (syslog) the following message: "logips2pp: Detected unknown logitech
> mouse model 0".
>

Does the mouse still work despite this message?

> The same system with a kernel 2.6.12-12 (Mandriva 10.1) worked properly.
>

How was it identified by 2.6.12? Could you please send me output of
cat /proc/bus/input/devices on 2.6.12 and 2.6.17?

-- 
Dmitry
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


Victor Fernandes said:
> Dear kernel gurus,
>
> I have a long experience with linux but not at the kernel level, so my
> apologies if this post is not appropriate for the list, but it seemed to
> me to be the only possible one to post my question.
>
> Obviously I've also tried to find the solution on the archives (and more)
> but found nothing appropriate.
>
> Problem: It appears that the new kernels, I've actually kernel 2.6.17-5
> (Mandriva 2007) installed, and tested others on the 2.6.x range, do not
> recognition my "Track Point" mouse anymore. I have on the boot logs
> (syslog) the following message: "logips2pp: Detected unknown logitech
> mouse model 0".
>
> The same system with a kernel 2.6.12-12 (Mandriva 10.1) worked properly.
>
> Is my mouse too old? Is this a bug? Are there any possibilities to solve
> the problem?
>
> Please Cc me directly on your replies because I'm not subscribe to the
> list, I hope this is OK. Obviously I'm more then happy to provide any
> required information.
>
> Thank you,
>
> Victor Fernandes
>
>


