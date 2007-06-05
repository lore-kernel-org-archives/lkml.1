Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbXFEJUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbXFEJUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762984AbXFEJT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:19:56 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:47110 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762920AbXFEJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:19:55 -0400
Message-ID: <466529DD.90605@gmail.com>
Date: Tue, 05 Jun 2007 11:16:13 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com> <20070604175751.GB3437@dhcp83-182.boston.redhat.com> <20070605021027.GD2498@localhost.localdomain>
In-Reply-To: <20070605021027.GD2498@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2007 04:10 AM, WANG Cong wrote:

> On Mon, Jun 04, 2007 at 01:57:51PM -0400, Jeff Garzik wrote:

>> A matter of opinion :)  I tend to think goto is special enough to
>> warrant column 1 unconditionally.  It is special, so it draws additional
>> attention over and above case labels.
>>
>> I and others have been tripped up when programmers "hide" goto
>> statements among regular statements.
>>
>> IMO goto warrants a big flashing "notice me" sign.

> Hmmm, perhaps.
> 
> So, it seems that we can reach an agreement. Any other comments or
> suggestions?

One more -- I absolutely agree with Jeff that goto should stand out as best as 
possible but I think that's actually more so when they're indented 2 columns.

Have been working on a legacy CD-ROM driver lately and puting "out:" labels at 2 
spaces started out as a personal style preference of Pekka Enberg (I used to put 
them at 0) but has grown on me. It makes them clearly fall inside the function, 
  not being aligned at the same level as the next function header, which makes 
for the "lowest effort visual scan" of all I feel. One is just too little for 
that, more than 2 is too much...

Here's the last version that was posted:

http://lkml.org/lkml/2007/6/4/50

It gets a little different visually when labels are mostly longer than a simple 
"out" or "again", or "error" or something like that but if someone's going to 
try to pin down the label style, I'd like the freedom to have two spaces in 
front of them...

Rene.

P.S: Your message had a Mail-Followup-To set which dropped yourself and turned 
the others from CCs into TOs. If you can help it, please no header tricks.
