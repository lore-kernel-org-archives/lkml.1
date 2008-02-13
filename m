Return-Path: <linux-kernel-owner+w=401wt.eu-S1765393AbYBMBc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765393AbYBMBc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYBMBcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:32:35 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50601 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754320AbYBMBce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:32:34 -0500
Date: Tue, 12 Feb 2008 19:32:29 -0600
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, rientjes@google.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212193229.edbff05a.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
	<20080212183158.3ff4ccd5.pj@sgi.com>
	<Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> Good. And remove the enum.
> 
> It would be better to add some sort of flags field?

On the other hand, despite my brilliant (hah!) endorsement
of bit field flags in my reply a few minutes ago, I'd settle
for (1) removing the enum, and (2) using a flags field and
more defines for the new stuff.  I will grant that Christoph
is correct that that form is more common in the kernel, and
there is something to be said for doing things in the most
common manner.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
