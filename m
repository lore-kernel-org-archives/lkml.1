Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYFLUKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYFLUKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYFLUKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:10:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37178 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753528AbYFLUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:10:36 -0400
Date: Thu, 12 Jun 2008 15:10:32 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ...
 on x86_64
Message-Id: <20080612151032.5a59309b.pj@sgi.com>
In-Reply-To: <86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
References: <20080612050609.88a8cf7f.pj@sgi.com>
	<86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
	<20080612111943.c140c4cb.pj@sgi.com>
	<86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> that function seems to increase the ebda to workaround some broken
> machine blindly.

Yes, true.

The reserve_ebda_region() has probably been like that for a while;
do you understand why it would be a problem conflicting with the
EFI memmap only now?

My other two concerns remain as well:

 2) Is what amounts to a change from calling reserve_bootmem()
    to calling reserve_early(), at the end of reserve_ebda_region()
    in the 32 bit case (now that it is merged with the 64 bit code)
    understood to be a desired and correct change?

 3) There has been quite a few patches restructuring this early
    memory reservation code over the last week.  What is the
    state of that work ... is it still "in progress" or is it
    thought to be complete?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
