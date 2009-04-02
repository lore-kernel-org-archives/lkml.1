Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZDBUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZDBUqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZDBUqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:46:02 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:54588 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZDBUqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:46:01 -0400
Message-ID: <49D523FB.2020504@nortel.com>
Date: Thu, 02 Apr 2009 14:45:47 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, peterz@infradead.org,
       akpm@linux-foundation.org
Subject: Re: Resend: /proc/<pid>/maps offset output broken in 2.6.29
References: <49CA8501.1000000@nortel.com>  <49D3F662.4050100@nortel.com> <1238659491.9041.133.camel@localhost> <Pine.LNX.4.64.0904021324070.16207@blonde.anvils> <49D4FB89.4070101@nortel.com> <Pine.LNX.4.64.0904021938270.25731@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904021938270.25731@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 20:45:49.0116 (UTC) FILETIME=[01306FC0:01C9B3D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:

> This is a cosmetic matter, not worth more than a couple of lines of
> code: I suggested masking off the high bits in the display, but when
> KAMEZAWA-san suggested just showing 0, it was hard to argue against
> his brutal simplicity.

<snip>

> Consider this change a fix: it used to show 00000000 before 2.6.7.
> 
> See http://lkml.org/lkml/2009/1/13/331 for one of the threads
> on the subject - but you've not tempted me to reopen it!

Okay, fair enough.  I'll change my code to deal with it.  Thanks for the 
explanation.

Chris
