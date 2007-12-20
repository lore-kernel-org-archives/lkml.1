Return-Path: <linux-kernel-owner+w=401wt.eu-S1762068AbXLTVku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068AbXLTVku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXLTVkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:40:41 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:10952 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXLTVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:40:40 -0500
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
X-Message-Flag: Warning: May contain useful information
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
	<20071219202323.GH2310@csclub.uwaterloo.ca>
	<Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>
	<20071220150255.GE2308@csclub.uwaterloo.ca>
	<Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
	<20071220162700.GF2308@csclub.uwaterloo.ca>
	<Pine.LNX.4.61.0712201615580.9531@chaos.analogic.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 20 Dec 2007 13:40:36 -0800
In-Reply-To: <Pine.LNX.4.61.0712201615580.9531@chaos.analogic.com> (linux-os@analogic.com's message of "Thu, 20 Dec 2007 16:23:12 -0500")
Message-ID: <ada1w9hyrhn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Dec 2007 21:40:37.0095 (UTC) FILETIME=[F53D7770:01C84350]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It doesn't seem to be something in .config. Do you know how to
 > reconfigure to get parameter passing put back like it was? Our
 > production applications have lots of assembly-language files
 > and I'm sure we are not going to be able to change all those!

32-bit x86 uses regparm=3 by default now since commit a1a70c25 ("i386:
always enable regparm"), which went in about a year ago.  To go back
to the old way, you'll just have to edit arch/x86/Makefile_32 (and
rebuild your whole kernel from a clean tree, obviously).

 - R.
