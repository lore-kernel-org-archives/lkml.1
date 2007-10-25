Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbXJYJz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbXJYJz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbXJYJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:55:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:48365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbXJYJzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:55:09 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: Is gcc thread-unsafe?
Date: Thu, 25 Oct 2007 11:55:03 +0200
User-Agent: KMail/1.9.6
Cc: davids@webmaster.com, "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKAEOKHLAC.davids@webmaster.com> <200710251447.51370.nickpiggin@yahoo.com.au> <2007-10-25-11-44-28+trackit+sam@rfc1149.net>
In-Reply-To: <2007-10-25-11-44-28+trackit+sam@rfc1149.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251155.03521.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 11:44:28 Samuel Tardieu wrote:
> >>>>> "Nick" == Nick Piggin <nickpiggin@yahoo.com.au> writes:
> 
> Nick> Either way, I think we really need a way to turn it off for
> Nick> Linux.
> 
> Someone would need to add an option to disable the "cselim" pass in
> GCC tree-ssa-phiopt.c as far as I can tell from reading GCC source.

Note the test case was for 3.4.x which doesn't have tree-ssa at all.
It does if-conversion on the RTL level 

-Andi


