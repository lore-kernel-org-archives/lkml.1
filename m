Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZAFP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZAFP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZAFP3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:29:10 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:47206 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZAFP3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:29:09 -0500
Message-Id: <496386EF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 06 Jan 2009 15:29:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Theodore Ts'o" <tytso@mit.edu>, "Sam Ravnborg" <sam@ravnborg.org>
Cc: <ccache@lists.samba.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
>In the short term, though, it would be nice if we could get back a
>simple way of making a kernel  object file using just cc, so that ccache
>and distcc could be functional again.   Does that seem reasonable?

Making the new logic dependent on a config option would seem reasonable
to me - of course at the expense of the respective Makefile becoming
even less readable.

Jan

