Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZHXJaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZHXJaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZHXJaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:30:13 -0400
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:51545 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbZHXJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:30:11 -0400
X-Greylist: delayed 3317 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 05:30:11 EDT
Date: Mon, 24 Aug 2009 10:34:33 +0200
From: Dick Streefland <dick@streefland.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: manual merge of the kconfig tree with the kbuild
	tree
Message-ID: <20090824083433.GA6147@streefland.net>
References: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2009-08-24 11:32, Stephen Rothwell wrote:
| Today's linux-next merge of the kconfig tree got conflicts in
| scripts/extract-ikconfig between commit
| 692d21e03cfc740684639b019ce9ad708930eb47 ("kconfig: simplification of
| scripts/extract-ikconfig") from the kbuild tree and commits
| fd3132d5815bf72aeec7d5ad87161b4831f8e48c ("kconfig: add check if end
| exists in extract-ikconfig") and 6be51ffc1791b72d11cef9bb0a578fe8c5d64c6a
| ("kconfig: have extract-ikconfig read ELF files") from the kconfig tree.
| 
| It looks like the kbuild patch obsoletes the first of the kconfig patches
| and may obsolete the second.  I used the kbuild version for now, but
| invite advice.

My simplified script that you merged from the kbuild tree will also
extract config information from ELF files. So both patches from the
kconfig tree are not needed anymore.

-- 
Dick
