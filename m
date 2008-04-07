Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYDGVAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYDGVAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYDGU77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:59:59 -0400
Received: from mga10.intel.com ([192.55.52.92]:26945 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbYDGU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:59:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,618,1199692800"; 
   d="scan'208";a="313526981"
Message-ID: <47FA8AB4.7060605@linux.intel.com>
Date: Mon, 07 Apr 2008 13:57:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071123.27411.jbarnes@virtuousgeek.org> <47FA7B58.6040907@tungstengraphics.com> <200804071259.19743.jbarnes@virtuousgeek.org> <47FA8826.2060802@tungstengraphics.com>
In-Reply-To: <47FA8826.2060802@tungstengraphics.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Hellström wrote:
> Ouch, so we'll be needing an ioremap_wc(), I guess. We probably 
> shouldn't use the linear kernel map for this anyway, since that would 
> require a chipset flush for each ring commit.  We can actually use 
> vmap() with a wc page protection for that, but an ioremap_wc() would 
> certainly save us a lot of trouble.

please don't use vmap() as a hack for mapping IO memory when you should use ioremap_wc()....
Lets get this thing right rather than finding whichever hack of the day
happens to work with the implementation from yesterday.
