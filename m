Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYKOH4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYKOH4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 02:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYKOH4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 02:56:38 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33774 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYKOH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 02:56:37 -0500
Date: Sat, 15 Nov 2008 08:57:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_OPTIMIZE_INLINING fun
Message-ID: <20081115075750.GA11109@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I do wonder whether there's some tweak we could make to page-flags.h
> which would stop this nonsense.  Change the inline functions back to
> macros?  I suspect that by itself wouldn't work, and my quick attempt
> to try it failed abysmally to compile, I've not the cpp foo needed.

Try declaring the inline functions as __always_inline
This undo the effect of CONFIG_OPTIMIZE_INLINING=n.

	Sam
