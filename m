Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYIJWcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYIJWcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYIJWbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:31:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42720
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYIJWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:31:52 -0400
Date: Wed, 10 Sep 2008 15:31:46 -0700 (PDT)
Message-Id: <20080910.153146.143573430.davem@davemloft.net>
To: dave@linux.vnet.ibm.com
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       nickpiggin@yahoo.com.au, akpm@linux-foundation.org, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct
 page
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221085260.6781.69.camel@nimitz>
References: <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
	<20080910012048.GA32752@balbir.in.ibm.com>
	<1221085260.6781.69.camel@nimitz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 10 Sep 2008 15:21:00 -0700

> This will really suck for sparse memory machines.  Imagine a machine
> with 1GB of memory at 0x0 and another 1GB of memory at 1TB up in the
> address space.

You just described the workstation I am typing this from :-)
