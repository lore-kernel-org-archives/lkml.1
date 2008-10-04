Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYJDPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYJDPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 11:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYJDPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 11:25:16 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35498 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751057AbYJDPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 11:25:15 -0400
Date: Sat, 4 Oct 2008 11:24:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Smith <dsmith@redhat.com>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081004152456.GB23398@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, David Smith <dsmith@redhat.com>,
	Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Wenji Huang <wenji.huang@oracle.com>,
	Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003195436.GA13506@Krystal>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 03:54:36PM -0400, Mathieu Desnoyers wrote:
> Here is a fix that should take care if this problem. Given I am not the
> modpost expert, let's see if I can get an ACK from Sam.

Tested-by: "Theodore Ts'o" <tytso@mit.edu>

It works, thanks!!  Can we get this pushed to Linus before 2.6.28
opens?  This is technically a regression since it was broken around
2.6.27-rc1.

Also, something we need to consider is getting distributions to ship
Modules.markers, and where it should be installed.  I would argue that
it belongs in /lib/modules/`uname -r`, so maybe "make modules_install"
should put it there?  This attention to deployability is going to be
important if markers are to be successfully used by applications such
as Systemtap.

						- Ted

