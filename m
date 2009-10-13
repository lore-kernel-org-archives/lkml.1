Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZJMMbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZJMMbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZJMMbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:31:47 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36537 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677AbZJMMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:31:45 -0400
Date: Tue, 13 Oct 2009 18:00:47 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>, vatsa@in.ibm.com,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20091013123047.GC26069@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com> <4AD466E5.4010206@openvz.org> <20091013120354.GF24787@MAIL.13thfloor.at> <4AD4705D.6020109@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD4705D.6020109@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:19:41PM +0400, Pavel Emelyanov wrote:
> > as I already stated, it seems perfectly fine for me 
> 
> You're not the only one interested in it, sorry. Besides, I
> got your point in "I'm find with it". Now get mine which is
> about "I am not".
> 
> > can be trivially mapped to the two values, by chosing a
> > fixed multiplicative base (let's say '1s' to simplify :) 
> > 
> >   with 50%, you get 1s/0.5s
> >   with 20%, you get 1s/0.2s
> >   with  5%, you get 1s/0.05s
> > 
> > well, you get the idea :)
> 
> No I don't.
> Is 1s/0.5s worse or better than 2s/1s?
> How should I make a choice?

I would say it depends on your requirement. How fast do you want to
respond back to the user? Wiht lower bandwidth, you would want to have
shorter periods so that the user would not get the impression that he
has to "wait" to get CPU time. But having a very short period is not a
good thing, since there are other considerations (such as the overhead of
hard limits).

thanks,
-- 
regards,
Dhaval
