Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZCNSPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZCNSPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZCNSPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:15:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37988 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZCNSPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:15:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YD0k4/gZChmz6e1ultCjry6D+NOrFbu2h3wSsLCKMiYaSwWdIeg2lAmcgyS8z28I1
	U5Vo4Ow2xMTzfG33Y43mw==
MIME-Version: 1.0
In-Reply-To: <20090313.191951.228619450.davem@davemloft.net>
References: <65634d660903131459m645eb468y3ad850a1fd56d447@mail.gmail.com>
	 <20090313.151913.21135937.davem@davemloft.net>
	 <65634d660903131724s49009177pdc11005aa76a4b56@mail.gmail.com>
	 <20090313.191951.228619450.davem@davemloft.net>
Date: Sat, 14 Mar 2009 11:15:21 -0700
Message-ID: <65634d660903141115w7e164134ycece307f041e93a9@mail.gmail.com>
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to submit 
	to upper layer
From: Tom Herbert <therbert@google.com>
To: David Miller <davem@davemloft.net>
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 7:19 PM, David Miller <davem@davemloft.net> wrote:
> From: Tom Herbert <therbert@google.com>
> Date: Fri, 13 Mar 2009 17:24:10 -0700
>
>> Enabling HW multi-queue has somewhat higher CPU
>> utilization though, the extra device interrupt load is not coming for
>> free.  We actually use the HW multi-queue in conjunction with our
>> software steering to get maximum pps (about 20% more).
>
> This is a non-intuitive observation.  Using HW multiqueue should be
> cheaper than doing it in software, right?
>

I suppose it may be counter-intuitive, but I am not making a general
claim.  I would only suggest that these software hacks could be a very
good approximation or substitute for hardware functionality.  This is
a generic way to get more performance out of deficient or lower end
NICs.
