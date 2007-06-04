Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbXFDHvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbXFDHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 03:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXFDHvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 03:51:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:27581 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbXFDHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 03:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NR3F5ICTa0CHxkotvWHmgF1P0vOQH6jWB7R7zSwspD3eFh/tkaM1/wkcmFwROSjz8P1MfYbD8A1RtP7b28+ndseK80q0Xb9CjLVvQAE2mbMxiE+wpBm01aNefpZtou4LvFIaFwL21eXsEO/mQM1/WPZ/W8XnyZOaBpVnXR0Wm7w=
Date: Mon, 4 Jun 2007 15:51:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070604075153.GB2074@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4663B84E.2060103@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 11:59:26PM -0700, Jeremy Fitzhardinge wrote:
>WANG Cong wrote:
>> I just wonder, if a goto label is nested in a while/for/if/switch block, aligning it in
>> the first column maybe a bit ugly. (I know mostly it is not in any while/for/if/switch block.)
>>   
>
>In general goto labels are not scoped, so there's no point in pretending
>they are.  It might make sense to indent a label deeper if you've
>actually declared it local (__label__).
>
>    J

OK. Thank you. I will take your advice.

A new version of this patch will come  soon. ;)

