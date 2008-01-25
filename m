Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYAYBSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYAYBSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYAYBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:18:41 -0500
Received: from gw.goop.org ([64.81.55.164]:43428 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYAYBSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:18:40 -0500
Message-ID: <479938ED.3070401@goop.org>
Date: Thu, 24 Jan 2008 17:18:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] percpu: Optimize percpu accesses
References: <20080123044924.508382000@sgi.com> <20080124224613.GA24855@elte.hu> <47992AA8.6040804@sgi.com> <20080125002543.GA931@elte.hu> <47993428.7000001@sgi.com>
In-Reply-To: <47993428.7000001@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> The hang though, I'm getting as well and am debugging it now (alibi
> slowly since it's happening so early.  Too bad grub doesn't have kdb
> in it... ;-)

I can reproduce under qemu, which means you can attach gdb to it.  I'll 
see if it happens to a Xen guest too.

    J
