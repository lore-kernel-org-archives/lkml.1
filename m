Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYE3HrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYE3HrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYE3HrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:47:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYE3HrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:47:15 -0400
Message-ID: <483FAF5B.3080408@redhat.com>
Date: Fri, 30 May 2008 09:40:11 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu>
In-Reply-To: <20080528122813.GA5502@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
>> +	__attribute__((section(".bss.page_aligned")));

> Sam, any ideas how to accomplish that best?

Have a define like this for them all?

#define page_aligned \
  __attribute__((aligned(4096))) \
  __attribute__((__section__ (".bss.page_aligned")))

cheers,
  Gerd

-- 
http://kraxel.fedorapeople.org/xenner/
