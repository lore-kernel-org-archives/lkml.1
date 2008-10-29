Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbYJ2G2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbYJ2G2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYJ2G2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:28:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYJ2G2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:28:09 -0400
Message-ID: <49080274.4040905@redhat.com>
Date: Wed, 29 Oct 2008 08:28:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de>
In-Reply-To: <20081028232944.GA3759@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Right... that was to add a guard page like the old vmalloc allocator.
> vmallocs still add their extra page too, so most of them will have
> a 2 page guard area, but I didn't think this would hurt significantly.
>
> I'm not against the patch, but I wonder exactly what is filling it up
> and how? (can you look at the vmalloc proc function to find out?

Maybe we're allocating two guard pages, but freeing only one?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

