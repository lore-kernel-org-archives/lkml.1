Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZLUQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZLUQnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZLUQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:43:21 -0500
Received: from pmx1.sophos.com ([213.31.172.16]:51033 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZLUQnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:43:20 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: alain@knaff.lu
Subject: 2.6.33-rc1: LZMA kernel fails to decompress
Date: Mon, 21 Dec 2009 16:43:18 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200912211643.18173.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 21/12/2009 16:43:18,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 21/12/2009 16:43:18,
	Serialize complete at 21/12/2009 16:43:18
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

When run under VMware, LZMA compressed 2.6.33-rc1 instantly reboots in the 
decompression stage. At least I suppose so, because switching to GZIP makes 
it work.

Kernel was configured via make oldconfig from a working 2.6.32-rc6. Only other 
difference is that kprobes are disabled in 33-rc1 and enabled in 32-rc6.

CPU on the server is Xeon 5110 if it helps.

I can post the .config if needed, in fact since I will be away after today, I 
will do it right now. But as a reply to this to ensure at least this post is 
not eaten by vger filters.

Tvrtko
