Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZKJGdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZKJGdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZKJGdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:33:09 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:45647 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZKJGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:33:08 -0500
Message-ID: <4AF90923.7030709@gmail.com>
Date: Tue, 10 Nov 2009 07:33:07 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Patch] net: fix incorrect counting in __scm_destroy()
References: <20091104100717.4785.57149.sendpatchset@localhost.localdomain>	<4AF15771.8060204@gmail.com> <20091104.044116.37320720.davem@davemloft.net> <4AF90461.5090800@redhat.com>
In-Reply-To: <4AF90461.5090800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 10 Nov 2009 07:33:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang a écrit :
> 
> Yes, this even happens after commit f8d570a47.
> 
> But after doing a bisect, we found another hrtimer patch fixes this
> problem, so it's not a bug of __scm_destroy().
> 
> Sorry for the noise.
> 

Thanks for the explanation !
