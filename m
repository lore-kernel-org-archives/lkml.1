Return-Path: <linux-kernel-owner+w=401wt.eu-S1030991AbXDPXgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030991AbXDPXgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031027AbXDPXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:36:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030991AbXDPXgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:36:44 -0400
Message-ID: <46240888.1040804@redhat.com>
Date: Mon, 16 Apr 2007 19:36:40 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zach Carter <linux@zachcarter.com>
CC: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG:  Bad page state errors during kernel make
References: <4622EDD3.9080103@zachcarter.com> <20070416035603.GD21217@redhat.com> <46230A3A.8060907@zachcarter.com>
In-Reply-To: <46230A3A.8060907@zachcarter.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Carter wrote:
> 
> Dave Jones wrote:
>> On Sun, Apr 15, 2007 at 08:30:27PM -0700, Zach Carter wrote:
>>  > list_del corruption. prev->next should be c21a4628, but was e21a4628
>>
>> 'c' became 'e' in that last address. A single bit flipped.
>> Given you've had this for some time, this smells like a hardware problem.
>> memtest86+ will probably show up something.
> 
> Hum.   I forgot to mention in my report that I had already run thru 10
> clean passes with memtest86+
> 
> Do you think there might be other bad hw, or another explanation?

memtest86 does not really stress everything a real kernel compile
would.

