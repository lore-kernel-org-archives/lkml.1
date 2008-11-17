Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYKQUEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYKQUEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYKQUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:04:46 -0500
Received: from smtp-out.google.com ([216.239.45.13]:19140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYKQUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:04:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=ump94R6OPlU3KnZKPfLPG5lj8xpIN6jgMN2IuHWvEsdsB1fWJbVB5EUfhOK0dnERF
	J+PFkcF9K4DwCUXnfj5NA==
MIME-Version: 1.0
In-Reply-To: <49218FB4.6090805@nortel.com>
References: <20081115011452.GA28135@google.com> <49218FB4.6090805@nortel.com>
Date: Mon, 17 Nov 2008 12:04:40 -0800
Message-ID: <b040c32a0811171204p4ce6d706j3ee2c018d0f33548@mail.gmail.com>
Subject: Re: busted CFS group load balancer?
From: Ken Chen <kenchen@google.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 7:37 AM, Chris Friesen wrote:
>> It appears that the fair-group load balancer in 2.6.27 does not work
>> properly.
>
> There was an issue fixed post 2.6.27 where the load balancer didn't work
> properly if there was one task per group per cpu.  You might try
> backporting commit 38736f4 and see if that helps.

Tested git commit 38736f4, it doesn't fix the problem I'm seeing.
