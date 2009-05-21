Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZEUJrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZEUJrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZEUJrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:47:42 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:54483 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZEUJrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:47:41 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Corey Minyard <minyard@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
	<20090516170959.8057c9e4.akpm@linux-foundation.org>
	<877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
	<87iqjxzjz4.fsf@tac.ki.iif.hu> <4A1326C5.4010308@acm.org>
	<87ljoriwcw.fsf@tac.ki.iif.hu> <4A143103.9050302@acm.org>
Date: Thu, 21 May 2009 11:47:28 +0200
In-Reply-To: <4A143103.9050302@acm.org> (Corey Minyard's message of "Wed, 20
	May 2009 11:34:11 -0500")
Message-ID: <878wkqpz2n.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard <minyard@acm.org> writes:

> Ferenc Wagner wrote:
>
>> Just out of interest, how often does the driver wake up to check
>> the inteface?
>
> When idle, the driver wakes up every 10ms to check for something on
> the driver.

Wow, 100 times per second, that sure sounds gross for piping out SEL
entries!  Though it certainly doesn't matter much for our servers, but
hasn't it got the potential to heavily tax laptop batteries?  Or is
that why ipmi_si isn't loaded automatically by udev?
-- 
Thanks,
Feri.
