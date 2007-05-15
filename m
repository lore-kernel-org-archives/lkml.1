Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXEOGpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXEOGpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXEOGpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:45:45 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:59705 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXEOGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o+ppbl7UJsx661pR+NiWGOtVB7mj9Dxbn2cLiL5T1PbFGmgcrK3ZEexSZG692PWdVY2gXnJme/jCSWg2wa5gnKmRRBadZqRqHtLXAhtOvLjiBYLnBe3Kk9+Cl03cAPD8GHSqniMt3wvtNqMZhywOv2l+HKPz03tOP/kw9MBEhIE=
Message-ID: <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
Date: Tue, 15 May 2007 14:45:43 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "pradeep singh" <2500.pradeep@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "Bahadir Balban" <bahadir.balban@gmail.com>,
       "Learning Linux" <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <366312910705142217geba69dbm98a6c0bf2aabb937@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
	 <366312910705142217geba69dbm98a6c0bf2aabb937@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> good enough, but i have a query regarding this then.
> On a 8K kernel stack system, doesn't interrupts share the stack associated
> with the current process which was interrupted?

Yes, I think so.

> Doesn't interrupt steals the CPU slice time allocated to the running process
> to run?

I don't think so but I am not sure.

> Doesn't it run in current process's context ?
>

No. I think the concept of process context is a higher-level logical
concept. Though the interrupt share stack with the interrupted
process, in my opinion it logically does not share the context with
the process.

> What am i missing here?
>
> Thanks
> ~psr
>


But I do not see the exact relationship between your specific queries
and the original question. Could you elaborate?
