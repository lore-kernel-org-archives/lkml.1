Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYC2GCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYC2GCF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 02:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYC2GBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 02:01:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48065 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYC2GBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 02:01:53 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47EDA4B9.6030801@goop.org>
References: <47ED8685.9040409@goop.org>
	 <1206751622.27091.20.camel@nimitz.home.sr71.net>
	 <47EDA4B9.6030801@goop.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 23:01:47 -0700
Message-Id: <1206770507.31896.8.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 19:08 -0700, Jeremy Fitzhardinge wrote:
> Perhaps.  Or we could get rid of it altogether.  There's only a single 
> user of the notifier (mm/slub.c), and given that it doesn't even use the 
> MEM_ONLINE notifier, we could just drop this part.

There is at least one other user that I know of, which is the ehea
driver.  They're running through patches now to use it.

Anyway, we need the notifier.  We're only going to get more and more
drivers that need notification.  There may be one user now, but that's
no reason to rip it out.  Feel free to revisit it in a year if there's
still only one user. :)

-- Dave

