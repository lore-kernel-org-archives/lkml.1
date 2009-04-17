Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbZDQQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbZDQQrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbZDQQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:47:28 -0400
Received: from gw.goop.org ([64.81.55.164]:58544 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbZDQQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:47:27 -0400
Message-ID: <49E8B29E.3050201@goop.org>
Date: Fri, 17 Apr 2009 09:47:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu>
In-Reply-To: <20090417162326.GG8253@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> No need to nak - just say you dont like it and it gets fixed :)
>
> I meant to suggest to Jeremy to measure the effect of this 
> out-of-lining, in terms of instruction count in the hotpath.

Once I get the pvops tracing to link properly, it should be fairly clear 
one way or the other.

    J
