Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXFDG7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXFDG7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 02:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbXFDG7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 02:59:38 -0400
Received: from gw.goop.org ([64.81.55.164]:38969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXFDG7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 02:59:37 -0400
Message-ID: <4663B84E.2060103@goop.org>
Date: Sun, 03 Jun 2007 23:59:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Chen Li-jun <cljun@xiyou.edu.cn>,
       Wang Ya-gang <lazy_linux@126.com>
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain>
In-Reply-To: <20070604045857.GE2161@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> I just wonder, if a goto label is nested in a while/for/if/switch block, aligning it in
> the first column maybe a bit ugly. (I know mostly it is not in any while/for/if/switch block.)
>   

In general goto labels are not scoped, so there's no point in pretending
they are.  It might make sense to indent a label deeper if you've
actually declared it local (__label__).

    J
