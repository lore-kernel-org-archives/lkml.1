Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZABNC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZABNC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZABNCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:02:16 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:37454 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbZABNCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=v++j5gGyXPu70+nxcVFfhdPvEJj6yZmtSTT3I2luOgdzAodBFXKu97Y3kDjfqK+CJS
         4G18EwSsQ5nREVGm0PGKQFpP3kAExTNNqJzm5mS78sv9vsp2EcslZhCmemlMN+z4qhH8
         J35GLe/SNHNHb71tEbDlJrUMqU7YL/P72fRzw=
Date: Fri, 2 Jan 2009 13:02:07 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: donash4@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: qdisc requeue stats
Message-ID: <20090102130206.GA4450@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226.142923.63754891.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-12-2008 23:29, David Miller wrote:
> From: "Don Ash" <donash4@gmail.com>
> Date: Sat, 27 Dec 2008 00:14:03 +0200
> 
>> Is there a way to see q->qstats.requeues statistics
>> (dev_requeue_skb()) ? I tried tc tool but it does not
>> show it...

Something like this should work: tc -s qdisc show
Otherwise more details are needed.

Jarek P.
