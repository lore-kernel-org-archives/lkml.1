Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZBGOCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZBGOCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 09:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZBGOC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 09:02:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48595 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920AbZBGOC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 09:02:28 -0500
Date: Sat, 7 Feb 2009 14:02:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       thomas@linux-os.sc.intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series -
 v2
Message-ID: <20090207140245.1e91a88f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090207004728.GA17586@linux-os.sc.intel.com>
References: <20090207004728.GA17586@linux-os.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 16:47:29 -0800
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> 
> For Intel 7400 series CPUs, the recommendation is to use a clflush on the
> monitored address just before monitor and mwait pair [1]. This clflush makes
> sure that there are no false wakeups from mwait when the monitored address
> was recently written to.

Given our mwait usages will very quickly go back to sleep in such a case
and it would almost certainly be one sleep only is this really worth the
effort ?
