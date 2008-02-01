Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbYBACL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbYBACL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYBACLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:11:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54979
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYBACLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:11:48 -0500
Date: Thu, 31 Jan 2008 18:12:09 -0800 (PST)
Message-Id: <20080131.181209.193710785.davem@davemloft.net>
To: davidn@davidnewall.com
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, jeff.chua.linux@gmail.com,
       linux-kernel@vger.kernel.org, ole@ans.pl, cups-bugs@easysw.com,
       netfilter-devel@vger.kernel.org
Subject: Re: cups slow on linux-2.6.24
From: David Miller <davem@davemloft.net>
In-Reply-To: <47A26C12.9020801@davidnewall.com>
References: <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu>
	<47A21945.2050005@trash.net>
	<47A26C12.9020801@davidnewall.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Newall <davidn@davidnewall.com>
Date: Fri, 01 Feb 2008 11:17:14 +1030

> Patrick McHardy wrote:
> > Jozsef Kadlecsik wrote:
> >> Strange, but there are a lot of incorrect checksum packets. How does
> >> it come on the loopback interface?
> >
> > Loopback doesn't perform full checksumming, so thats expected.
> 
> The question remains: How do loopback packets get incorrect checksum? 
> Where and how can they get corrupted?

There are zeros there, which is an incorrect checksum most
of the time.

Tcpdump is just not knowledgable about this and tries to
validate the checksum as if it were computed correctly.
