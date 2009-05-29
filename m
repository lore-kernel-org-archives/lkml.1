Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZE2G1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZE2G1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZE2G04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:26:56 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15184 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbZE2G0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:26:55 -0400
Message-Id: <4A1F9C4F020000780000337B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 29 May 2009 07:26:55 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <TeHeo@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: percpu memory setup and num_possible_cpus() vs. nr_cpu_ids
References: <4A1EBA000200007800003197@vpn.id2.novell.com>
 <4A1F2E6E.6030105@novell.com>
In-Reply-To: <4A1F2E6E.6030105@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <teheo@novell.com> 29.05.09 02:38 >>>
>There's other related larger issue.  It looks like possible but
>offline configuration can be quite common with virtualization and
>allocating for all possible cpus on boot can waste problematic amount
>of space, so the plan is to allocate only for online cpus on boot and
>allocate the rest as cpus come online.  This will require audit of
>percpu users and probably a new cpumask representing cpus which have
>ever been up.
>
>The issue you're describing should be solved when the above is
>implemented, right?

Yes, I think so.

Jan

