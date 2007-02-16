Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXBPHXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXBPHXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXBPHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:23:36 -0500
Received: from gw.goop.org ([64.81.55.164]:45095 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961AbXBPHXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:23:35 -0500
Message-ID: <45D55BF7.30704@goop.org>
Date: Thu, 15 Feb 2007 23:23:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 11/21] Xen-paravirt: Add apply_to_page_range() which applies
 a function to a pte range.
References: <20070216022449.739760547@goop.org>	<20070216022531.344125142@goop.org>	<20070215223727.6819f962.akpm@linux-foundation.org>	<45D55805.908@goop.org> <20070215231936.073fadd3.akpm@linux-foundation.org>
In-Reply-To: <20070215231936.073fadd3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I guess your pte-at-a-time walker could be quite simply implemented underneath
> the smaps pmd-at-a-time walker.
>   

Yes, converting should be pretty simple.  There aren't many users in
Xen, but they are moderately performance critical (fork, exec and exit),
so using batching would be good.

    J
