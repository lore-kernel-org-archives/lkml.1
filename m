Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZCRApX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZCRApX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCRApK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:45:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45189 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZCRApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:45:08 -0400
Date: Wed, 18 Mar 2009 09:45:02 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI.
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
In-Reply-To: <49BFA1D7.8020302@windriver.com>
References: <20090317185152.47CD.E1E9C6FF@jp.fujitsu.com> <49BFA1D7.8020302@windriver.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>> Each calibration of this has 1 milli second.
> >>> Do you think 5 msec is too long?
> >>>       
> >> This shouldn't matter when booting.  Anyway, I think it's possible to
> >> increase TICK_CALIBRATE without losing too much accuracy.
> >>     
> >
> > Hmm. If the person who is trying to reduce boot time for fastboot dislikes this impact,
> > then I'll try Vojtech-san's way.
> >   
> 
> That probably makes sense -- if it is extremely rare, and if you get two
> values that are the same (within some small delta) then you probably
> are 99.99% confident that you have the right data.

Ok. I'll make it.

Thanks for your comment.


-- 
Yasunori Goto 


