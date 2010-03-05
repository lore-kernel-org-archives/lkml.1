Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0CEUbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:31:20 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:50377 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817Ab0CEUbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:31:19 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Date: Fri, 5 Mar 2010 21:31:10 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org
References: <20100305025435.GA6836@linux.vnet.ibm.com> <201003051818.10486.elendil@planet.nl> <20100305201051.GG6764@linux.vnet.ibm.com>
In-Reply-To: <20100305201051.GG6764@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003052131.12199.elendil@planet.nl>
X-OriginalArrivalTime: 05 Mar 2010 20:31:13.0087 (UTC) FILETIME=[CC3EC4F0:01CABCA2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropping cloos as that address is bouncing my mails.)

On Friday 05 March 2010, Paul E. McKenney wrote:
> s/you're over-designing this/you are freaking paranoid/

Whatever makes you happy :-)

> With that change, I plead guilty to charges as read.  But again, I am
> worried about the case where one person generates the .config file
> and someone else is reading it.

Not sure that's very relevant. A person reading it will still get the same 
oldfashioned basic info as when a build is done from a tree that's not 
under an SCM. And he won't really be in a position where he can fix the 
errors anyway.
