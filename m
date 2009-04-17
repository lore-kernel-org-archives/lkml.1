Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZDQRTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZDQRTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZDQRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:19:12 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:46954 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbZDQRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:19:11 -0400
Message-ID: <49E8BA08.8020908@nortel.com>
Date: Fri, 17 Apr 2009 11:19:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop> <alpine.DEB.1.10.0904170941020.11877@qirst.com> <1239977776.23397.4590.camel@laptop> <alpine.DEB.1.10.0904171021360.20239@qirst.com> <1239979901.23397.4638.camel@laptop> <alpine.DEB.1.10.0904171100510.21575@qirst.com> <20090417153520.GA29968@elte.hu> <alpine.DEB.1.10.0904171142050.13734@qirst.com> <1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>
In-Reply-To: <20090417164918.GK8253@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2009 17:19:07.0745 (UTC) FILETIME=[9D97A510:01C9BF80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> it's even simpler than that: use a user-space loop and an alert() 
> based signal-handler triggered measurement to count the number of 
> loops user-space can execute, per second.

Alternately, just measure how long it takes to execute a given (large) 
number of loops.  This avoids the signal handler.

Chris

