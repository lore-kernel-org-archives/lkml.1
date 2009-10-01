Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZJAVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZJAVDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZJAVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:03:16 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41789 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZJAVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <1254430820.5033.4.camel@localhost.localdomain>
References: <1254345112.8837.9.camel@localhost.localdomain>
	 <20091001132012.GA16975@amt.cnet>
	 <1254416336.6787.6.camel@localhost.localdomain>
	 <1254430820.5033.4.camel@localhost.localdomain>
Date: Thu, 1 Oct 2009 16:03:19 -0500
Message-ID: <90eb1dc70910011403q31218381tec865b1ecd361eff@mail.gmail.com>
Subject: Re: INFO: task kjournal:337 blocked for more than 120 seconds
From: Javier Guerra <javier@guerrag.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mcao@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 4:00 PM, Shirley Ma <mashirle@us.ibm.com> wrote:
> I talked to Mingming, she suggested to use different IO scheduler. The
> default scheduler is cfg, after I switch to noop, the problem is gone.

deadline is the most recommended one for virtualization hosts.  some
distros set it as default if you select Xen or KVM at installation
time.  (and noop for the guests)


-- 
Javier
