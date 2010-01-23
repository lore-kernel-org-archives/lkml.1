Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705Ab0AWKBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0AWKBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 05:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0AWKBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 05:01:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37143
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab0AWKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 05:01:29 -0500
Date: Sat, 23 Jan 2010 02:01:40 -0800 (PST)
Message-Id: <20100123.020140.231150448.davem@davemloft.net>
To: jpirko@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH net-next-2.6] net: introduce a macro to traverse
 through uc_list easily
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100122151301.GC2609@psychotron.redhat.com>
References: <20100122151301.GC2609@psychotron.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Fri, 22 Jan 2010 16:13:02 +0100

> Therefore that would be good to introduce a macro that can be used to traverse
> through addresses in the list without caller knowing anything about the type of
> the list. I think this kind of an abstraction is appropriate on this place.
> Also during the phase of changing, the macro can use the original list and onc ...
> What do you think about this? Please comment.

Yes this is the way to do it, three steps:

1) Add interface macros that iterate using the existing
   datastructure

2) Convert drivers to use #1

3) Convert to list_head

