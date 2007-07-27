Return-Path: <linux-kernel-owner+w=401wt.eu-S1765130AbXG0TJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765130AbXG0TJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbXG0TJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:09:07 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:38710 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbXG0TJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:09:06 -0400
Message-ID: <46AA42CA.4060004@nortel.com>
Date: Fri, 27 Jul 2007 13:08:58 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com>
In-Reply-To: <20070727184418.GV9840@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2007 19:09:02.0035 (UTC) FILETIME=[97D9F230:01C7D081]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:

> The pps_event() is now protected by a spinlock against
> pps_register_source() and pps_unregister_source()...

Locks protect data, not code.  It may make more sense to identify the 
specific data being protected by the spinlock.

Chris
