Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYHJH2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYHJH2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYHJH2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:28:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17796 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYHJH2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CIhYEP3Yg8aBPCIuJrXfBBiiW4ZikcpKQlVfMO65X4rfRD5SDhVE+AU8s1i3XF/p0i
         gL7E1S7qXP84SbDbdmLJlwYxs566DOjLxu+IHuuLQzZ4fWMDdOgqNO4MToJL6pmWhE/S
         4miOYXWQEQrXrd/VwcPmwI6pNh5TnDLZqFy+E=
Date: Sun, 10 Aug 2008 11:28:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bradley Hanna <brahan.ml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Programming the apic when no external to cpu timer is present?
Message-ID: <20080810072838.GA7249@lenovo>
References: <489E341F.2030809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489E341F.2030809@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Bradley Hanna - Sat, Aug 09, 2008 at 08:19:43PM -0400]
| I am working with an embedded testing board that has no timer external
| to the cpu other than an rtc.  How does linux go about programming the
| local cpu timer (apic) to raise hardware interrupts?
| 
| thanks for your patience,
| 
| brahan
| 

you could take a look on apic_(32|64).c. Here is the
function you need I hope - setup_APIC_timer

		- Cyrill -
