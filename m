Return-Path: <linux-kernel-owner+w=401wt.eu-S936708AbXHGWtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936708AbXHGWtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbXHGWtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:49:40 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:46285 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbXHGWtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:49:39 -0400
Message-ID: <46B8F6FB.8070904@nortel.com>
Date: Tue, 07 Aug 2007 16:49:31 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Chris Snook <csnook@redhat.com>, Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com> <46B8E64E.7010708@nortel.com> <Pine.LNX.4.64.0708080005260.26397@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708080005260.26397@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2007 22:49:35.0381 (UTC) FILETIME=[3A158C50:01C7D945]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 7 2007 15:38, Chris Friesen wrote:

>>That volatile is there precisely to force the compiler to dereference it every
>>single time.

> Actually, the dereference will be done once (or more often if registers
> are short or the compiler does not feel like keeping it around),
> and the read from memory will be done on every iteration ;-)

My bad.  You are, of course, correct.  :)

Chris
