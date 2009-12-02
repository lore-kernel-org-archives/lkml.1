Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZLBXSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZLBXSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZLBXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:18:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZLBXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:18:44 -0500
Message-ID: <4B16F5AC.3060201@zytor.com>
Date: Wed, 02 Dec 2009 15:18:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
References: <20091202144334.GA30359@elte.hu>	 <1259765735.12870.42.camel@gandalf.stny.rr.com>	 <20091202162715.GB9710@Krystal>	 <1259773888.12870.61.camel@gandalf.stny.rr.com>	 <20091202180633.GF9710@Krystal>	 <1259777987.12870.70.camel@gandalf.stny.rr.com>	 <20091202190135.GA23316@Krystal>	 <1259781578.12870.78.camel@gandalf.stny.rr.com>	 <4B16EC06.6010706@redhat.com>	 <1259794005.12870.102.camel@gandalf.stny.rr.com>	 <20091202225736.GA14770@Krystal>  <4B16F389.4090801@zytor.com> <1259795605.12870.104.camel@gandalf.stny.rr.com>
In-Reply-To: <1259795605.12870.104.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 03:13 PM, Steven Rostedt wrote:
> 
> So, would you think:
> 
> TRACE_CLASS - Declare a class
> TRACE_EVENT - defines an event for said class (different meaning than before)
> TRACE_CLASS_EVENT - Declares a class and an event
> 
> is the better naming?
> 

Minus the legacy issue, yes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

