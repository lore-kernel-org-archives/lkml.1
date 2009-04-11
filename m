Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZDKMQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZDKMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZDKMQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:16:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58046 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZDKMQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:16:44 -0400
Date: Sat, 11 Apr 2009 14:19:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
Message-ID: <20090411121911.GR14687@one.firstfloor.org>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com> <49DE195D.1020303@redhat.com> <1239332455.6384.108.camel@yhuang-dev.sh.intel.com> <49E08762.1010206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E08762.1010206@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, but we can allocate the maximum number, no?  it's a fairly small 
> amount of memory.

There are 255 banks worst case which need upto 4 (in theory 5) MSRs each

-Andi
