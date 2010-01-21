Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685Ab0AUUky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab0AUUky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511Ab0AUUkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:40:53 -0500
Received: from mail.crca.org.au ([67.207.131.56]:39970 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0AUUkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:40:53 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B58BC31.1040406@crca.org.au>
Date: Fri, 22 Jan 2010 07:42:25 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during	suspend/resume
 (was: Re: Memory allocations in .suspend	became very unreliable)
References: <20100120085053.405A.A69D9226@jp.fujitsu.com>	<201001202221.34804.rjw@sisk.pl>	<20100121091023.3775.A69D9226@jp.fujitsu.com> <201001212121.50272.rjw@sisk.pl>
In-Reply-To: <201001212121.50272.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Rafael J. Wysocki wrote:
> On Thursday 21 January 2010, KOSAKI Motohiro wrote:
>>  - Ask all drivers how much they require memory before starting suspend and
>>    Make enough free memory at first?
> 
> That's equivalent to reworking all drivers to allocate memory before suspend
> eg. with the help of PM notifiers.  Which IMHO is unrealistic.

What's unrealistic about it? I can see that it would be a lot of work,
but unrealistic? To me, at this stage, it sounds like the ideal solution.

Regards,

Nigel
