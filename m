Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbYDDAru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbYDDAru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYDDAro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:47:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57864 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYDDAro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:47:44 -0400
Subject: Re: [PATCH 4 of 6] hotplug-memory: use common online_page
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>
References: <a2a6c0b2e3fdc19d18b4.1207267544@localhost>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 17:47:41 -0700
Message-Id: <1207270061.943.21.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> Apart from x86-32, all architectures use an identical online_page.
> Define it weakly in mm/memory_hotplug.c so that architectures can
> override it if necessary.

This is OK, but I do think the __weak stuff can make it a bit
counter-intuitive to track down which version is actually getting used.
Are there any people the currently override that __weak?

If not, we should probably just kill it.

-- Dave

