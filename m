Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZADBYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZADBYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 20:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZADBYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 20:24:20 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41659
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZADBYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 20:24:20 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Embedded Linux mailing list <linux-embedded@vger.kernel.org>
Subject: PATCH [0/3]: Simplify the kernel build by removing perl v2
Date: Sat, 3 Jan 2009 19:24:15 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net>
In-Reply-To: <200901020207.30359.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031924.15869.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated set of patches to remove use of perl from the kernel build's 
"hot path" (roughly defined as "make allnoconfig; make; make 
headers_install").

This update incorporates feedback from Sam Ravnborg, Ted Tso, Joe Perches, 
Ingo Oeser, and others.  It also fixes an integer overflow error in the first 
patch, and all three scripts have been retested under dash.
