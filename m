Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYE2VMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYE2VMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYE2VMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:12:09 -0400
Received: from mga05.intel.com ([192.55.52.89]:26394 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbYE2VMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:12:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,563,1204531200"; 
   d="scan'208";a="570172054"
Message-ID: <483F1C17.8040207@linux.intel.com>
Date: Thu, 29 May 2008 14:11:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: greg@kroah.com, dwmw2@infradead.org, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
References: <1212077700.26088.83.camel@shinybook.infradead.org>	<20080529164745.GA21763@kroah.com>	<483F1232.4010003@linux.intel.com> <20080529.140919.160813310.davem@davemloft.net>
In-Reply-To: <20080529.140919.160813310.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Arjan, by definition the firmware has to be tied to the kernel somehow.
> THe datastructure and other aspects are often tied directly to
> the firmware version loaded.

agreed that there are cases like this, and I have no personal objection to having
those in the kernel.

> If debian or whoever else have these concernes and want to rip the
> firmware out, it is one hundred percent their problem to patch things
> out of the kernel tree they use.

I don't care at all about the argument from that camp.


My aim was more the opposite: be able to get MORE firmware easily used/loaded,
not less. Right now it's a royal pain for users to get all the right pieces of
firmware.... having ONE place to put all that would go a long way of making that
side of things easier.

If you want to argue that that should be in the kernel tarbal itself, you won't
hear me complain. But others will... and for that a 2nd tarbal might well be the answer.
Just we shouldn't need 100 tarbals.
