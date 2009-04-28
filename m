Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZD1Qof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZD1Qof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZD1QoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:44:25 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50311 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbZD1QoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O63rb1OIDtvh054Hkuh4n/eL38sIYNwV6g58nQRepO07BrUSgU/qIuCLASuW81/kK0
         toF5PlNyc+7oV3gFzO7wBfCLZgDK5jWv6YRd/w3hvzm5fSegKvpDHDGdgXmo9+eO9kU8
         OJGsamcmWP/iXtR4rTKuj5hU6A40tpGM4Y0Ts=
Date: Tue, 28 Apr 2009 18:44:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428164420.GA7337@nowhere>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu> <20090428154046.GA32381@Krystal> <20090428163300.GD5978@nowhere> <20090428163825.GA2030@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428163825.GA2030@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:38:25PM -0400, Mathieu Desnoyers wrote:
> No, read-write lock is a "special case" where it does not deadlock if
> you have an interrupt handler taking the read lock over another read
> lock. It's just the write lock that _must absolutely_ disable
> interrupts.


Ah, you're right, I was thinking with spinlock rules in mind :)


> However, the "latency race" scenario I explained above applies here,
> because the write lock disables interrupts and the read locks doesn't.
> 
> Mathieu
> 

