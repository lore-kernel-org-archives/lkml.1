Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZBLBZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZBLBZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZBLBZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:25:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZBLBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:25:08 -0500
Message-ID: <49937A46.7050602@zytor.com>
Date: Wed, 11 Feb 2009 17:24:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: git pull request for tip/tracing/urgent
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com> <20090211012856.GA4921@nowhere> <20090211090229.GG21105@elte.hu> <49929763.3080608@kernel.org> <20090211095325.GD20518@elte.hu>
In-Reply-To: <20090211095325.GD20518@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> hm ... doh, yes. I think we even had a bug in this area.
> 
> Why is it implemented like this? These semantics seem to make no sense.
> 

They don't, which is why .pushsection/.popsection now exists.

.section/.previous really are rather broken, but like many things with 
broken semantics there is too much that expect the broken semantics now...

	-hpa

