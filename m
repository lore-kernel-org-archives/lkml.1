Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYIMAOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYIMAOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbYIMANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240AbYIMANu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:13:50 -0400
Date: Fri, 12 Sep 2008 17:13:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: herton@mandriva.com.br, me@bobcopeland.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br, lcapitulino@mandriva.com.br,
       draconux@gmail.com, dlallement@mandriva.com, pterjan@mandriva.com,
       axboe@kernel.dk
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
Message-Id: <20080912171302.8f48cf3e.akpm@linux-foundation.org>
In-Reply-To: <200809121659.21743.david-b@pacbell.net>
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	<200809121646.09641.david-b@pacbell.net>
	<20080912165222.9ed7fc25.akpm@linux-foundation.org>
	<200809121659.21743.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 16:59:20 -0700
David Brownell <david-b@pacbell.net> wrote:

> > > > ________________________________________________________________disk->disk_name, p);
> > > > -______________________________________________continue;
> > > > ________________________________}
> > 
> > wtf-your-email-client-is-insane.
> 
> I have no idea where that came from.  Wasn't in the original or
> in my copy.
> 

Your email client added it.  What I sent:

0008A0: 68 65 63 6B 2E 63 0A 40 40 20 2D 35 34 30 2C 37      >heck.c@@@ -540,7<
0008B0: 20 2B 35 34 30 2C 36 20 40 40 20 69 6E 74 20 72      > +540,6 @@ int r<
0008C0: 65 73 63 61 6E 5F 70 61 72 74 69 74 69 6F 6E 73      >escan_partitions<
0008D0: 28 73 74 72 75 63 74 20 67 65 6E 64 69 73 6B 20      >(struct gendisk <
0008E0: 2A 64 69 0A 20 09 09 69 66 20 28 66 72 6F 6D 20      >*di@ @@if (from <
0008F0: 2B 20 73 69 7A 65 20 3E 20 67 65 74 5F 63 61 70      >+ size > get_cap<
000900: 61 63 69 74 79 28 64 69 73 6B 29 29 20 7B 0A 20      >acity(disk)) {@ <
000910: 09 09 09 70 72 69 6E 74 6B 28 4B 45 52 4E 5F 45      >@@@printk(KERN_E<
000920: 52 52 20 22 20 25 73 3A 20 70 25 64 20 65 78 63      >RR " %s: p%d exc<
000930: 65 65 64 73 20 64 65 76 69 63 65 20 63 61 70 61      >eeds device capa<
000940: 63 69 74 79 5C 6E 22 2C 0A 20 09 09 09 09 64 69      >city\n",@ @@@@di<
000950: 73 6B 2D 3E 64 69 73 6B 5F 6E 61 6D 65 2C 20 70      >sk->disk_name, p<
000960: 29 3B 0A 2D 09 09 09 63 6F 6E 74 69 6E 75 65 3B      >);@-@@@continue;<
000970: 0A 20 09 09 7D 0A 20 09 09 72 65 73 20 3D 20 61      >@ @@}@ @@res = a<

your reply:

000C50: A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0      >@@@@@@@@@@@@@@@@<
000C60: A0 70 72 69 6E 74 6B 28 4B 45 52 4E 5F 45 52 52      >@printk(KERN_ERR<
000C70: 20 22 20 25 73 3A 20 70 25 64 20 65 78 63 65 65      > " %s: p%d excee<
000C80: 64 73 20 64 65 76 69 63 65 20 63 61 70 61 63 69      >ds device capaci<
000C90: 74 79 5C 6E 22 2C 0A 3E 20 A0 A0 A0 A0 A0 A0 A0      >ty\n",@> @@@@@@@<
000CA0: A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0      >@@@@@@@@@@@@@@@@<
000CB0: A0 A0 A0 A0 A0 A0 A0 A0 A0 64 69 73 6B 2D 3E 64      >@@@@@@@@@disk->d<
000CC0: 69 73 6B 5F 6E 61 6D 65 2C 20 70 29 3B 0A 3E 20      >isk_name, p);@> <
000CD0: 2D A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0      >-@@@@@@@@@@@@@@@<
000CE0: A0 A0 A0 A0 A0 A0 A0 A0 63 6F 6E 74 69 6E 75 65      >@@@@@@@@continue<

I've ceased to be amazed at the stupid tricks which MUAs inflict upon
us in recent years.

> 
> > > So that now deserves to be KERN_WARN not KERN_ERR, yes?
> > 
> > spose so.
> > 
> > I'm fairly unenthused about the recent KERN_correctness fad since it
> > went and broke sysrq-T output (you have to set the loglevel beforehand
> > to avoid getting only partial output).
> 
> On development systems I generally "echo 8 > /proc/sysrq*"
> to make sure KERN_DEBUG isn't hidden.

Yeah, but it's another step we need to walk reporters through when
diagnosing problems.  Madly machine-gunning each others' feet.

> In this case it's just that I saw flamage a few minutes
> earlier from someone trying to keep a distro boot from
> spewing scarey messages for things that were NOT errors.
> Like ... this message.  :)

Lots of our messages should just be deleted.  I think people put them
in at development time and are then reluctant to clean them up.

Proposed algorithm:

- choose the message well so it can be googled for.

- time passes

- google for it

- if nobody's reporting it: kill.

