Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXDASyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXDASyj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933897AbXDASyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:54:39 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:61713 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895AbXDASyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:54:38 -0400
Date: Sun, 01 Apr 2007 20:54:37 +0200
Message-Id: <1714153317@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, the point of an upper limit might be to keep loop devices from  
> chewing up too much memory on a system.  IE: To fail allocating more  
> loopdevs before you run OOM and start killing random userspace  
> processes.

ok, sounds reasonable. 

but - not very sure here, but don`t you need to be root for creating loop devices and don`t you have many other ways to chew up too  much memory then, anyway ?


> -----Ursprüngliche Nachricht-----
> Von: Kyle Moffett <mrmacman_g4@mac.com>
> Gesendet: 01.04.07 20:44:04
> An: devzero@web.de
> CC: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org
> Betreff: Re: [patch] remove artificial software max_loop limit


> On Apr 01, 2007, at 14:36:11, devzero@web.de wrote:
> >> Blame on the dual meaning of max_loop that it uses currently: to
> >> initialize a set of loop devices and as a side effect, it also sets
> >> the upper limit.  People are complaining about the former constrain,
> >> isn't it?  Does anyone uses the 2nd meaning of upper limit?
> >>
> >> - Ken
> >
> > what sense would it make to set an upper limit at all?
> >
> > we`re so happy to have none anymore :)
> 
> Well, the point of an upper limit might be to keep loop devices from  
> chewing up too much memory on a system.  IE: To fail allocating more  
> loopdevs before you run OOM and start killing random userspace  
> processes.
> 
> Cheers,
> Kyle Moffett
> 
> 


_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

