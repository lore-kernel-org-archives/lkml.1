Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXCEDRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXCEDRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXCEDRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:17:55 -0500
Received: from web52511.mail.yahoo.com ([206.190.48.194]:36931 "HELO
	web52511.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752613AbXCEDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:17:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=u7SaFLiKXyBtJkmMfWVy0fqNHrFROmWXf/lqFmOrbi5JS45A5vOEKBqpmMR2Rh07CnMfsF1BRAjpe4RWbJT42zv2fps2vIAqrn2X51CXJOSy/qzrKnPmRHpVNxQvm4hfKKl1en+CzvTONAHlnL+DvLwaTWZrRy5dl7JgRxhYhyQ=;
X-YMail-OSG: YPKtumsVM1n0lSDc7IPqiTuM3uI.8iTglZukswTrZtFnmAmn8mfsWl.qTlunxQPkIcDzzKsmPqniazAffZenHj9UZugK.8K8RQwNY3b.s6ZQ9eXjyuu6a_vZ0Z_t1Uxg_gS9gxgoIXSGo0fZRQTJlmSeug--
Date: Sun, 4 Mar 2007 19:17:53 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0703050312050.23714@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <697121.9642.qm@web52511.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Mar 4 2007 15:10, Marc Perkel wrote:
> >> On Mar 4 2007 08:25, Marc Perkel wrote:
> >> >I'm running the latest OpenVZ kernel 2.6.18. I'm
> >> not
> >> >sure if this is a factor or not as the problem
> >> occurs
> >> >without starting any VEs.
> >> >
> >> >I've never used raid 10 before (stripes on top
> of 2
> >> >mirrors) so I don't have anything to compare
> this
> >> >with. I'm just wondering if I'm doing something
> >> wrong.
> >> 
> >> Are you using raid1+0 (3 md devices) or raid10 (1
> >> raid device)?
> >> Depending on which, you might want to try the
> other.
> >
> >
> >I'm using 3 devices. Can you use just one? If so -
> >how?
> >How do I create a raid 10 using mdadm?
> 
> mdadm -C /dev/md0 -N nicearray -b internal -e 1.0 -l
> 10 -n 4 /dev/sd[abcd]1
> 
> for example. (See the manpage for details.)
> 

Thanks - because of your suggestion I had found the
instructions. But you have some interesting options
set. 

-N nicearray -b internal -e 1.0

Are these important? I can restart the process. I
think that I found my original problem. I forgot to
use:

pci=nommconf iommu=soft




 
____________________________________________________________________________________
We won't tell. Get more on shows you hate to love 
(and love to hate): Yahoo! TV's Guilty Pleasures list.
http://tv.yahoo.com/collections/265 
