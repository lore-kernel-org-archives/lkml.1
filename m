Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYGRXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYGRXi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYGRXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:38:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbYGRXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:38:50 -0400
Message-ID: <48812962.1010809@zytor.com>
Date: Fri, 18 Jul 2008 16:38:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ftrace.git] Immedate Values Optimized Jump Fix
References: <20080717031721.GA24504@Krystal> <20080718161523.GY6875@elte.hu> <20080718183124.GA31768@Krystal> <4880F410.3090804@zytor.com> <20080718211205.GA5423@Krystal>
In-Reply-To: <20080718211205.GA5423@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> The generated code you are talking about will generate a different code
> pattern, won't it (e.g. saving the registers on the stack before the
> branch) ? And in this case, we fall-back on the standard immediate
> values.
> 

Not necessarily, and you *certainly* can't rely on pattern analysis to 
determine when it's unsafe.

	-hpa
