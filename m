Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXFEBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXFEBh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFEBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:37:17 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:29167 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbXFEBhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hjU53/xwl6JRMFwNPMFBpZ8ztWLY432K4CzWusomWjBYH8ehoMGUIyb+Tu1ZCTpdjdw8p3UR+RIQ03z3sJRGxIrvBbXJhGj/gzlDr7V46SURfw9snvwF7cUg5bWPo0X/d+FNzoOfSubBZivI40AoYeKf4tQyNTkJgo4Es3tj5VQ=
Date: Tue, 5 Jun 2007 09:37:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels (-v2)
Message-ID: <20070605013735.GA2388@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Sam Ravnborg <sam@ravnborg.org>, Jeff Garzik <jeff@garzik.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Al Viro <viro@ftp.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	Chen Li-jun <cljun@xiyou.edu.cn>, Wang Ya-gang <lazy_linux@126.com>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org> <20070604081938.GC2074@localhost.localdomain> <20070604183014.GB16187@uranus.ravnborg.org> <466461C4.2050806@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466461C4.2050806@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 12:02:28PM -0700, Jeremy Fitzhardinge wrote:
>Sam Ravnborg wrote:
>> If local(__label__) really so widely used in the kernel that it deserves
>> a place in coding-style?
>> A quick grep did not say so.
>>   
>
>Probably not, and its use shouldn't be (even tacitly) encouraged.  It's
>only really useful for defining a local label within a macro, and
>there's probably something wrong with your macro if you need a local label.
>
>    J

I agree. Local labels maybe useful in macros.
If someone will use local labels in his code some day, we shouldn't force him
to align his labels in the first column.

