Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZJAVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZJAVAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZJAVAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:00:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43599 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZJAVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:00:39 -0400
Subject: Re: INFO: task kjournal:337 blocked for more than 120 seconds
From: Shirley Ma <mashirle@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mcao@us.ibm.com
In-Reply-To: <1254416336.6787.6.camel@localhost.localdomain>
References: <1254345112.8837.9.camel@localhost.localdomain>
	 <20091001132012.GA16975@amt.cnet>
	 <1254416336.6787.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 14:00:20 -0700
Message-Id: <1254430820.5033.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I talked to Mingming, she suggested to use different IO scheduler. The
default scheduler is cfg, after I switch to noop, the problem is gone. 

So there seems a bug in cfg scheduler. It's easily reproduced it when
running the guest kernel, so far I haven't hit this problem on the host
side.

If I need to file a bug for some one to look at, please let me know.

Thanks
Shirley

