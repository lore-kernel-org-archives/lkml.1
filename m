Return-Path: <linux-kernel-owner+w=401wt.eu-S965222AbXAaPRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222AbXAaPRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965239AbXAaPRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:17:03 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60407 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965222AbXAaPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:17:01 -0500
Date: Wed, 31 Jan 2007 20:46:47 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fair-user scheduler
Message-ID: <20070131151647.GA23004@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070126060142.GA2487@in.ibm.com> <45BA4B57.1070604@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA4B57.1070604@nortel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 12:41:27PM -0600, Chris Friesen wrote:
> As Kirill brought up, why does it take so much more time?  Are you 
> thrashing the cache?

Yes, the default 1-sec control window I had was causing lot of
thrashing. See http://lkml.org/lkml/2007/1/31/142

> Presumably this would be made generic, as in per-"group" rather than per 
> user?

Ideally yes! But I am trying to apply the solution to an existing problem
and later extend for other needs as well.

> >	- Fairsched aware SMP load balance NOT addressed (yet)
> 
> This is kind of important, no?

Yea again! I have again avoided it to keep the patch simple at first.
Based on interest/response, I can address this later.


-- 
Regards,
vatsa
