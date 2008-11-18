Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYKRXHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYKRXHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYKRXHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:07:04 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:44087 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYKRXHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:07:03 -0500
Message-ID: <49234A79.8070707@nortel.com>
Date: Tue, 18 Nov 2008 17:06:33 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Chris Friesen" <cfriesen@nortel.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: BUG? timer_create() with SIGEV_THREAD not working (at least on
 ppc64)
References: <4922E9EC.3070606@nortel.com> <492326B5.10203@nortel.com>
In-Reply-To: <492326B5.10203@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2008 23:06:36.0583 (UTC) FILETIME=[4E815B70:01C949D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> I'm getting suspicious of either glibc or my version of strace, as it 
> shows the child thread calling rt_sigtimedwait() with an empty signal set.

Looks like glibc was the culprit.  It works fine with a newer version. 
Sorry for the false alarm.

Chris
