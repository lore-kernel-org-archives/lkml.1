Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYARBnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYARBnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYARBnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:43:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbYARBnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:43:08 -0500
Message-ID: <479002B6.9030607@zytor.com>
Date: Thu, 17 Jan 2008 20:36:54 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
References: <1200611078.5724.46.camel@brick>	<478FDE76.3070309@zytor.com>	<1200612389.5724.63.camel@brick>	<478FF9F3.9030604@zytor.com>	<1200618952.5724.85.camel@brick> <20080118013712.4090526FA0B@magilla.localdomain>
In-Reply-To: <20080118013712.4090526FA0B@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> It's indeed true that &pt_regs is truly the esp value for x86-32
> kernel-mode trap frames.  Because this nonobvious calculation is 
> only right for a kernel mode pt_regs and not for a user-mode one,
> I think it would be better to use a name for the inline/macro that
> makes this quite clear, rather than one so generic as "stack_addr".

Indeed.  This was certainly highly nonobvious in the current code.

	-hpa

