Return-Path: <linux-kernel-owner+w=401wt.eu-S937938AbZAPWDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937938AbZAPWDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbZAPWCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:02:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:58667 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765728AbZAPWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=keVJFAbVUUQh83vGhyav7nZojpPePqTi05hw56YFhYyjqoA9F4bJJ0SGw7/ZaMlUCi
         VtQSnDrN3LpSaYyUpwebC/ae6p04NxYH8WxCgpnJrw7IuendM77Y9ieKHG5pdl1bMCzV
         y8v+4T2Wzjk29fQpqopnTCGA8D8wEPimgC1ug=
Subject: Re: [PATCH] infiniband: remove __constant_{endian} uses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ada4ozyewua.fsf@cisco.com>
References: <1232065920.11986.3.camel@brick>  <ada4ozyewua.fsf@cisco.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 14:02:22 -0800
Message-Id: <1232143342.6737.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 13:59 -0800, Roland Dreier wrote:
> > Roland, the necessary byteorder rework is now in -linus mainline
>  > and all arches have moved over, I'm starting to remove the uses
>  > of the __constant_* helpers now that they are equivalent.
> 
> This looks good, thanks.  I assume the expectation is that this should
> be queued for the next merge window?
> 
> Code generation should be unaffected, right?
> 

Your call, it's only a name change, the implementation on the back end is
now the same for both, so I expect the generated code to be identical.

But it is obviously not urgent, so holding for 2.6.30 is just fine.

Harvey

