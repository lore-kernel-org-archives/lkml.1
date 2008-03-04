Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbYCDB2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbYCDB2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYCDB2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:28:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127AbYCDB17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:27:59 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [rfc 10/10] Pageflags: Land grab
From: Andi Kleen <andi@firstfloor.org>
References: <20080304000452.514878384@sgi.com>
	<20080304000734.383475547@sgi.com>
Date: Tue, 04 Mar 2008 02:27:55 +0100
In-Reply-To: <20080304000734.383475547@sgi.com> (Christoph Lameter's message of "Mon\, 03 Mar 2008 16\:05\:02 -0800")
Message-ID: <p73tzjn5ld0.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:
>
> The page flags situation becomes very tight. The remaining 6 bits must then
> be used as section ids. Via a lookup table we can determine the node ids from
> the section id. So it would work.
>
> However, we would have no page flags left. Any additional page flag will
> reduce the number of available sparsemem sections to half.

I have an upcoming, soon to be posted, project that needs one page
flag on 32bit and two on 64bit. I would request that you leave
at least that many over.

-Andi
