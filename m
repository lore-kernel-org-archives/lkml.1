Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYENVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYENVoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYENVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:43:55 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56711 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYENVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:43:53 -0400
Date: Wed, 14 May 2008 22:43:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Sage Weil <sage@newdream.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover, performance.
Message-ID: <20080514214347.GD23758@shareable.org>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <20080514143105.GB14987@shareable.org> <20080514150052.GA15826@2ka.mipt.ru> <20080514213251.GB23758@shareable.org> <482B5BB6.3040308@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482B5BB6.3040308@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Definitely.  "several leaders" aka partitioning is also becoming 
> increasing paired with efforts at enhancing locality of reference.  Both 
> Google and Amazon sort their distributed tables lexographically, which 
> [ideally] results in similar data being stored near each other.
> 
> A bit of an improvement over partitioning-by-hash, anyway, for some 
> workloads.

As with B-trees on disks, and in-memory structures, application
knowledge of locality is very much worth passing to the storage layer.

-- Jamie
