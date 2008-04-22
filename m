Return-Path: <linux-kernel-owner+w=401wt.eu-S1762744AbYDVSlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762744AbYDVSlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYDVSkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:40:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:19030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYDVSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=o5J0/e1RzrZhCTuf78zEQDgT/SRtnbY+XCxvYLYFh+1FG12+au6g7i3vPIwefOQMjtPiiWNPjxl/Q/dWzuwAly+AKeYGIznYR3dclLygmBUBnH42oYbB26kb1DXxqnZuXprrFM2AwYbXk+C2OrQPRueoKga19NZw9IKb9S7qMz8=
Date: Tue, 22 Apr 2008 23:36:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       orenl@cs.columbia.edu, nick@nick-andrew.net
Subject: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object creation
	with a specified id)
Message-ID: <20080422193612.GA15835@martell.zuzino.mipt.ru>
References: <20080418054459.891481000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418054459.891481000@bull.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:44:59AM +0200, Nadia.Derbey@bull.net wrote:
>    . echo "LONG XX" > /proc/self/task/<my_tid>/next_id
>      next object to be created will have an id set to XX
>    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/task/<my_tid>/next_id
>      next object to be created will have its ids set to XX0, ... X<n-1>
>      This is particularly useful for processes that may have several ids if
>      they belong to nested namespaces.

Can we answer the following questions before merging this patch:

a) should mainline kernel have checkpoint/restart feature at all
b) if yes, should it be done from kernel- or userspace?

Until agreement will be "yes/from userspace" such patches don't make
sense in mainline.

