Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZADVtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZADVtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZADVtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:49:23 -0500
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:55397 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZADVtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:49:22 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 22:49:40 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Duane Griffin <duaneg@dghda.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <495FF9CE.2020908@ribosome.natur.cuni.cz> <495FFBA8.10804@shaw.ca>
In-Reply-To: <495FFBA8.10804@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042249.41616.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009, Robert Hancock wrote:
> I agree, there should be a way to force it to mount "really read only" 
> so it doesn't try to replay the journal. That might require just 
> ignoring the journal content, which may result in the FS appearing 
> corrupt, but for recovery/forensics purposes that seems better than 
> nothing..

For forensics you ALWAYS get a copy of the full disk first, 
which you set read only with blockdev --setro /dev/$MYDISK.

You then restore from this copy.


Best Regard

Ingo Oeser, been there, done that
