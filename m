Return-Path: <linux-kernel-owner+w=401wt.eu-S937576AbXLQXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937576AbXLQXWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763016AbXLQXVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:21:35 -0500
Received: from mga06.intel.com ([134.134.136.21]:7674 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937370AbXLQXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="242938550"
Message-ID: <476703A4.7000401@linux.intel.com>
Date: Mon, 17 Dec 2007 15:17:56 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, protasnb@gmail.com,
       tytso@thunk.org
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu>	 <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
In-Reply-To: <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
>> +       static char target[80];
>  ...
>> +               sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
>> +                       "%02x%02x%02x%02x%02x%02x",
> 
> [80] is overkill ... [37] bytes should be enough (unless I went
> cross-eyed counting the "%02x" :-)
> 

%02x doesn't guarantee that it's at most 2, but at LEAST 2...
