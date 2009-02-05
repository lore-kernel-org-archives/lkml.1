Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZBEUPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZBEUPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZBEUP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:15:26 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38503 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZBEUP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:15:26 -0500
Date: Thu, 5 Feb 2009 20:14:42 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: wli@movementarian.org
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
In-Reply-To: <20090205195817.GF10229@movementarian.org>
Message-ID: <Pine.LNX.4.64.0902052013230.12955@blonde.anvils>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu>
 <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu>
 <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <20090205194932.GB3129@elte.hu>
 <20090205195817.GF10229@movementarian.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, wli@movementarian.org wrote:
> 
> The RW bit needs to be allowed to become read-only for hugetlb COW.
> Changing it over to the 32-bit method is a bugfix by that token.

If there's a bugfix to be made there, of course I'm in favour:
but how come we've never seen such a bug?  hugetlb COW has been
around for a year or two by now, hasn't it?

Hugh
