Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbZKFTOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbZKFTOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759625AbZKFTOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:14:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50568 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbZKFTOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:14:45 -0500
Date: Fri, 6 Nov 2009 20:14:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC MM] mmap_sem scaling: only scan cpus used by an mm
Message-ID: <20091106191448.GD819@basil.fritz.box>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1> <20091106073946.GV31511@one.firstfloor.org> <alpine.DEB.1.10.0911061352320.22205@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911061352320.22205@V090114053VZO-1>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 01:53:35PM -0500, Christoph Lameter wrote:
> One way to reduce the cost of the writer lock is to track the cpus used
> and loop over the processors in that bitmap.

Can't you use the same mask as is used for TLB flushing?

-Andi
