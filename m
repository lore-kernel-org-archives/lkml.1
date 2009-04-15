Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbZDOJVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbZDOJVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZDOJVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:21:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49149
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbZDOJVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:21:41 -0400
Date: Wed, 15 Apr 2009 02:21:31 -0700 (PDT)
Message-Id: <20090415.022131.157811430.davem@davemloft.net>
To: jpirko@redhat.com
Cc: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jgarzik@pobox.com, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
 dev_addr_list
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090415083223.GF21342@psychotron.englab.brq.redhat.com>
References: <20090415081819.GB21342@psychotron.englab.brq.redhat.com>
	<49E59A1C.9030108@cn.fujitsu.com>
	<20090415083223.GF21342@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Wed, 15 Apr 2009 10:32:24 +0200

> This patch introduces a new list in struct net_device and brings a set of
> functions to handle the work with device address list. The list is a replacement
> for the original dev_addr field and because in some situations there is need to
> carry several device addresses with the net device. To be backward compatible,
> dev_addr is made to point to the first member of the list so original drivers
> sees no difference.
> 
> Note: patch adding list_first_entry_rcu (currently in Ingo's tip tree) needed.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>

Jiri, please add some distinguishing text to your subject lines when
you post fixed up version of patches.  Like "v2" or something like
that, and make a note under the commit message of the changes you've
made from the previous version.

Otherwise I think it's a dup (because I get a thousand copies anyways)
and will just delete it both in my inbox and on patchwork.

Thanks.
