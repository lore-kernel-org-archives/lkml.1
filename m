Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZC3TDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZC3TDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbZC3TDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:03:01 -0400
Received: from main.gmane.org ([80.91.229.2]:57288 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbZC3TDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:03:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.29
Date: Mon, 30 Mar 2009 15:02:44 -0400
Message-ID: <gqr50k$4aq$1@ger.gmane.org>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-176.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <49D0710A.1030805@ursus.ath.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas T.Auer wrote:
> On 30.03.2009 02:39 Theodore Tso wrote:
>> All I can do is apologize to all other filesystem developers profusely
>> for ext3's data=ordered semantics; at this point, I very much regret
>> that we made data=ordered the default for ext3.  But the application
>> writers vastly outnumber us, and realistically we're not going to be
>> able to easily roll back eight years of application writers being
>> trained that fsync() is not necessary, and actually is detrimental for
>> ext3.

> And still I don't know any reason, why it makes sense to write the
> metadata to non-existing data immediately instead of delaying that, too.
> 
Here I have the same question, I don't expect or demand that anything be done in 
a particular order unless I force it so, and I expect there to be some corner 
case where the data is written and the metadata doesn't reflect that in the 
event of a failure, but I can't see that it ever a good idea to have the 
metadata reflect the future and describe what things will look like if 
everything goes as planned. I have had enough of that BS from financial planners 
and politicians, metadata shouldn't try to predict the future just to save a ms 
here or there. It's also necessary to have the metadata match reality after 
fsync(), of course, or even the well behaved applications mentioned in this 
thread haven't a hope of staying consistent.

Feel free to clarify why clairvoyant metadata is ever a good thing...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

