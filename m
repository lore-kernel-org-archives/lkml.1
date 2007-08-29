Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXH2Ibp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXH2Ibp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXH2Ibg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:31:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:13643 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbXH2Ibf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:31:35 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: David Miller <davem@davemloft.net>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Wed, 29 Aug 2007 10:31:30 +0200
User-Agent: KMail/1.8.2
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
References: <200708281319.03903.ossthema@de.ibm.com> <46D51BD7.6040904@de.ibm.com> <20070829.012916.02298847.davem@davemloft.net>
In-Reply-To: <20070829.012916.02298847.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291031.31923.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 10:29, David Miller wrote:
> From: Jan-Bernd Themann <ossthema@de.ibm.com>
> Date: Wed, 29 Aug 2007 09:10:15 +0200
> 
> > In the end I want to reduce the CPU utilization. And one way
> > to do that is LRO which also works only well if there are more
> > then just a very few packets to aggregate. So at least our
> > driver (eHEA) would benefit from a mix of timer based polling
> > and plain NAPI (depending on load situations).
> > 
> > If there is no need for a generic mechanism for this kind of
> > network adapters, then we can just leave this to each device
> > driver.
> 
> No objections from me either way, if something works then
> fine.
> 
> Let's come back to this once you have a tested sample implementation
> that does what you want, ok?

Sounds good
