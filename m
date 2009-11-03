Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZKCTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZKCTER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZKCTEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:04:16 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:44611 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKCTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:04:16 -0500
Date: Tue, 3 Nov 2009 12:04:20 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Message-ID: <20091103190420.GY10555@parisc-linux.org>
References: <1257273488.9427.27.camel@mulgrave.site> <20091103105921.160d5599.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103105921.160d5599.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 static inline void strsrip_tail(char *str)
 {
-	char *x __used;
-	x = strstrip(str);
+	char *x = strstrip(str);
+	BUG_ON(x != str);
 }

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
