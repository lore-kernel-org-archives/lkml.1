Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZJZTeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZJZTeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZJZTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:34:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48705 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZJZTeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:34:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AE5F9B9.2010707@s5r6.in-berlin.de>
Date: Mon, 26 Oct 2009 20:34:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Noah Watkins <noah@noahdesu.com>
CC: "Leonidas ." <leonidas137@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com> <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com> <E1A2BB8B-F291-4C9E-B095-39F0AE7A0587@noahdesu.com>
In-Reply-To: <E1A2BB8B-F291-4C9E-B095-39F0AE7A0587@noahdesu.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noah Watkins wrote:
>> So we can safely assume that pointer assignment will be done in an
>> atomic manner?
> 
> See the the comment above rcu_assign_pointer in
> include/linux/rcupdate.h

This comment only talks about ordering, not about atomicity.

Again, AFAIR the ISO C spec should explain what is going to be
guaranteed atomic and what might not be atomic.

rcu_assign_pointer() itself does rely on atomicity of pointer
assignments though, like lots of code elsewhere in the kernel.
-- 
Stefan Richter
-=====-==--= =-=- ==-=-
http://arcgraph.de/sr/
