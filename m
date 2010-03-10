Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0CJMnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:43:50 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:23771 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753422Ab0CJMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:43:47 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v6 0/3] net: reserve ports for applications using fixed port numbers
Date: Wed, 10 Mar 2010 14:42:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-2-686; KDE/4.3.2; i686; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, nhorman@tuxdriver.com,
       eric.dumazet@gmail.com
References: <1267233952-5856-1-git-send-email-opurdila@ixiacom.com> <m1vddbdhmo.fsf@fess.ebiederm.org> <4B976503.4050702@redhat.com>
In-Reply-To: <4B976503.4050702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003101442.47192.opurdila@ixiacom.com>
X-OriginalArrivalTime: 10 Mar 2010 12:42:47.0306 (UTC) FILETIME=[2FF5AEA0:01CAC04F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010 11:23:15 you wrote:
> Eric W. Biederman wrote:
> > I would add the restriction that the values in the list of ranges
> > always must be increasing, and in general restrict the set of accepted
> > values as much as possible.  If we don't accept it now we don't have
> > to worry about some userspace application relying on some unitended
> > side effect a few years into the future.
> 
> I don't think this is good.
> 
> Suppose that when I just want to add one port into the list and keep the
> original ones, I want to do this:
> 
> orig=$(cat ip_local_reserved_ports)
> new_list="$orig, $new_one"
> echo "$new_list" > ip_local_reserved_ports
> 
> If we add this restriction, the above could be failed if the new port
> is lower than the original ones. This will be not convenient.
> 
> > I think it is a serious bug that you clear the destination bitmap
> > in the middle of parsing it.  That will either open or close all
> > ports in the middle of parsing, and I can't see how that would
> > ever be a good thing.
> 
> Agreed.
> 
> By the way, Octavian, any new updates?
> 

Sorry, didn't got time to work on this lately, but I will submit a new version 
I hope end of this week to address Eric's comments.

