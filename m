Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZAOJLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZAOJLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZAOJKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:10:46 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:44116 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZAOJKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:10:41 -0500
Message-Id: <496F0BC2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 15 Jan 2009 09:11:14 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: <ccache@lists.samba.org>, "Sam Ravnborg" <sam@ravnborg.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <1231953379.14825.29.camel@laptop>
In-Reply-To: <1231953379.14825.29.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Peter Zijlstra <peterz@infradead.org> 14.01.09 18:16 >>>
>So what's the current status on this, could we get it reverted ASAP or
>add that CONFIG_ switch (default N)?
>
>Leaving the build system broken for so long just isn't cool.

It is my understanding that Sam was looking at doing a partial revert first.
If that doesn't work out, doing the CONFIG_* thing would be pretty trivial
(I merged it into my local patch, and hence would simply have to extract it).

Sam?

Jan


