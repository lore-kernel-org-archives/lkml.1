Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbYLaLrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbYLaLrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYLaLrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:47:32 -0500
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:42512 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755535AbYLaLrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:47:32 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 06:47:31 EST
X-YMail-OSG: 0GOAo6AVM1lu5cxsID.ClWpmUTSkouROjfL1ZvjvyMX8OJzl9Y6TXr1UySfzMrFMuNx2MX3JAcTjs9kRzrMffbb.RwcuBXpSgAWZYYuYr.GxR11ZPe1PFH7w95_5aVMnKObGGK0zJu0q1E13ZJbFAC6r4EYsg1FstvfB6DWzl4RjV54uZn._VZuRXbv4DETi
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <20081230231152.10427.50620.stgit@hermosa.site> <87fxk5ur0h.fsf@basil.nowhere.org> <1230688589.3470.45.camel@hermosa.site> <20081231024609.GQ496@one.firstfloor.org>
Date: Wed, 31 Dec 2008 03:40:49 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [PATCH 0/2] pdflush fix and enhancement
To: Andi Kleen <andi@firstfloor.org>,
       "Peter W. Morreale" <pmorreale@novell.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <67303.72946.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please CC me on replies, I am not subscribed to LKML.


----- Original Message ----
> From: Andi Kleen <andi@firstfloor.org>
> To: Peter W. Morreale <pmorreale@novell.com>
> Cc: Andi Kleen <andi@firstfloor.org>; linux-kernel@vger.kernel.org
> Sent: Wednesday, December 31, 2008 3:46:09 AM
> Subject: Re: [PATCH 0/2] pdflush fix and enhancement
> 

snip

> > I actually think the question is: Why not allow the admin to control
> > this?  Since it seems like this is a matter of policy based on machine
> > configuration. 
> 
> The kernel should know the current machine config and most 
> admins don't really want to do very fine grained configuration;
> they expect the system to perform well out of the box. That is
> why it is adventageous to try to come up with good auto tuning.
> 

 Independent of the patch in question, the problem with this seems to me that [some/many of] the kernel developers [seem to] try to get it right for 100% of all thinkable use-cases. But this fails to take into account that:

- you cannot think of every single use-case. And not only because predicting furure use-cases is difficult
- getting it right for every case very often creates complexity that leads to subtle problems tha are hard to analyse and fix
- it may waste developer ressources
- and, think about it,  do we really want  the kernel to be smarter than ourselves ? :-)

 You are right that the kernel should work out of the box most of the times. And it usually is pretty good at that. But there are corner-cases where more flexibility for the admins is desirable - if only to debug a problem without doing deep code hacking. So we should be careful adding tuning-knobs, but we should also admit that sometimes they are useful.


Happy New Year
Martin

