Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYEOUFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYEOUFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYEOUFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:05:38 -0400
Received: from mga06.intel.com ([134.134.136.21]:38173 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830AbYEOUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:05:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,493,1204531200"; 
   d="scan'208";a="281911230"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Andrew Morton <akpm@linux-foundation.org>, david.vrabel@csr.com
Subject: Re: [BUG] Re: 2.6.26-rc2-mm1 - x86_32 oops on modprobe wusbcore
Date: Thu, 15 May 2008 13:05:33 -0700
User-Agent: KMail/1.9.9
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org> <200805152021.25916.m.kozlowski@tuxland.pl> <20080515115816.dcde0952.akpm@linux-foundation.org>
In-Reply-To: <20080515115816.dcde0952.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805151305.35041.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2008, Andrew Morton wrote:
> On Thu, 15 May 2008 20:21:25 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> > Hello,
> > 
> > 	To get this I simply modprobe wusbcore. modprobe itself ends with
> > SIGSEGV. This comes from x86_32.
> 
> Thanks.  Let's add some cc's...

This was fixed by David Vrabel recently, s/g arrays weren't 
proerly initialized (I am to blame for that).

David?

