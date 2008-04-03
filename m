Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYDCPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYDCPBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbYDCPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:00:53 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56059
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbYDCPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:00:52 -0400
Date: Thu, 3 Apr 2008 17:00:48 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: Fixup return value handling of emm_notify()
Message-ID: <20080403143341.GA9603@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com> <20080402212515.GS19189@duo.random> <Pine.LNX.4.64.0804021427210.30516@schroedinger.engr.sgi.com> <1207219246.8514.817.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207219246.8514.817.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 12:40:46PM +0200, Peter Zijlstra wrote:
> It seems to me that common code can be shared using functions? No need
> FWIW I prefer separate methods.

kvm patch using mmu notifiers shares 99% of the code too between the
two different methods implemented indeed. Code sharing is the same and
if something pointer to functions will be faster if gcc isn't smart or
can't create a compile time hash to jump into the right address
without having to check every case: .
