Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZKFRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZKFRKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 12:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZKFRKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 12:10:17 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:53364 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759364AbZKFRKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:10:16 -0500
Date: Fri, 6 Nov 2009 12:08:54 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Andi Kleen <andi@firstfloor.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: Subject: [RFC MM] mmap_sem scaling: Use mutex and percpu counter
 instead
In-Reply-To: <20091106073946.GV31511@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0911061208370.5187@V090114053VZO-1>
References: <alpine.DEB.1.10.0911051417370.24312@V090114053VZO-1> <alpine.DEB.1.10.0911051419320.24312@V090114053VZO-1> <87r5sc7kst.fsf@basil.nowhere.org> <alpine.DEB.1.10.0911051558220.7668@V090114053VZO-1> <20091106073946.GV31511@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Andi Kleen wrote:

> Yes but all the major calls still take mmap_sem, which is not ranged.

But exactly that issue is addressed by this patch!

