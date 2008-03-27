Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbYC0M1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbYC0M1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbYC0M1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:27:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:8158 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYC0M1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aD3rM7v0WPwStqKLTussyY/uP6x6m0ASd2gAWzo10Yj4k5Rx/jGPyJnwplnyf8B+PTyxTmcW2MJ2Mn5nKB+WhZOEaO6I9qZf9TyyicyJGPFThUf8NJI9lGmWvfGDuYe22513eDNgsNfdIV430v4kQK4U6G1pXX9PjqmbV8JVv0E=
Date: Thu, 27 Mar 2008 13:32:48 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Marcus Better <marcus@better.se>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, shemminger@linux-foundation.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327123248.GD2845@ami.dom.local>
References: <20080327085542.GA2778@ami.dom.local> <20080327021812.601776b8.akpm@linux-foundation.org> <1206615379.8514.502.camel@twins> <20080327.040334.25440988.davem@davemloft.net> <47EB8C06.4030306@better.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EB8C06.4030306@better.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 12:59:02PM +0100, Marcus Better wrote:
> David Miller wrote:
>> Can some test if using local_irq_{save,restore}() in
>> napi_complete() cures this lockdep warning?

Isn't it now justified enough without lockdep's ack?

> I cannot reproduce the bug, so cannot help much.

Marcus, you've helped here very much and enough!

Thanks,
Jarek P.
