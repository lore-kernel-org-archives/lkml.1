Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbYBETPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbYBETPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbYBETPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:15:25 -0500
Received: from relay2.sgi.com ([192.48.171.30]:37493 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759756AbYBETPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:15:23 -0500
Date: Tue, 5 Feb 2008 13:15:17 -0600
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rientjes@google.com
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
Message-Id: <20080205131517.1189104f.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802051050300.12425@schroedinger.engr.sgi.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080202090914.GA27723@one.firstfloor.org>
	<20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1202149243.5028.61.camel@localhost>
	<20080205143149.GA4207@csn.ul.ie>
	<1202225017.5332.1.camel@localhost>
	<Pine.LNX.4.64.0802051011400.11705@schroedinger.engr.sgi.com>
	<1202236056.5332.17.camel@localhost>
	<Pine.LNX.4.64.0802051050300.12425@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> Can we fix up his patch to address the immediate issue?

Since any of those future patches only add optional modes
with new flags, while preserving current behaviour if you
don't use one of the new flags, therefore the current behavior
has to work as best it can.

Therefore fixes such as this to address immediate issues
are probably needed.  Yup.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
