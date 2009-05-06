Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZEFGes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZEFGes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZEFGej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:34:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZEFGej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:34:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Gt9LhPFDHqne+r7IvBVevVwnux1S0qoINdCIpMTYUf7IhmPtslTOPPalHV4q5okhx
	rkG+yjRYi5Q4zG0raAbGw==
Date: Tue, 5 May 2009 23:34:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>, LMMML <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - fix comment
 and make it __init
In-Reply-To: <20090506061923.GA4865@lenovo>
Message-ID: <alpine.DEB.2.00.0905052333390.9824@chino.kir.corp.google.com>
References: <20090506061923.GA4865@lenovo>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Cyrill Gorcunov wrote:

> The caller of setup_per_zone_inactive_ratio is module_init function.
> No need to keep the callee after is completed as well.
> Also fix a comment.
> 
> CC: David Rientjes <rientjes@google.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: David Rientjes <rientjes@google.com>

There's no need to specify -mmotm on the subject line since it isn't 
specific to that tree, this applies to HEAD just fine.
