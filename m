Return-Path: <linux-kernel-owner+w=401wt.eu-S936358AbXJQCg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936358AbXJQCg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762299AbXJQCgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:36:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761090AbXJQCgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:36:45 -0400
Date: Tue, 16 Oct 2007 22:36:42 -0400
From: Dave Jones <davej@redhat.com>
To: Arnaud Fontaine <arnaud@andesi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error: Eeek! page_mapcount(page) went negative! (-1) with
	different process and kernels
Message-ID: <20071017023642.GB3397@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arnaud Fontaine <arnaud@andesi.org>, linux-kernel@vger.kernel.org
References: <sa564176ksz.fsf@Toushirou.duckcorp.org> <20071016183510.GB25480@redhat.com> <sa5ejfu64t5.fsf@Toushirou.duckcorp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sa5ejfu64t5.fsf@Toushirou.duckcorp.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 01:03:02AM +0200, Arnaud Fontaine wrote:
 > >>>>> "Dave" == Dave Jones <davej@redhat.com> writes:
 > 
 >     Dave> Many of these that I've  seen have turned out to be a hardware
 >     Dave> problem.  Try running memtest86+  on that machine for a while.
 >     Dave>  It doesn't  catch all  problems, but  it will  highlight more
 >     Dave> common memory faults.
 > 
 > Hello,
 > 
 > We ran memtest86+ before production, it  was about one month ago. Do you
 > think it could come from that anyway?

Not impossible. Hardware failures can occur at any time.
Somewhat unlikely though.  As I mentioned, memtest also doesn't trap
all hardware problems.  I have a board that passes memtest with flying
colours, yet dies under even slight load. Examination of the board
shows that it has leaking capacitors.

	Dave

-- 
http://www.codemonkey.org.uk
