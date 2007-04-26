Return-Path: <linux-kernel-owner+w=401wt.eu-S933798AbXDZJZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbXDZJZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbXDZJZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:25:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:47668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933805AbXDZJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:24:57 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mm] x86_64: kill 19000+ sparse warnings
Date: Thu, 26 Apr 2007 11:24:52 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20070425224509.46153baa.randy.dunlap@oracle.com>
In-Reply-To: <20070425224509.46153baa.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261124.52386.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 07:45:09 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Eliminate 19439 (!!) sparse warnings like:
> include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long

Sparse is just wrong here. The C standard does make it unsigned long long
automatically

-Andi
