Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXIZQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXIZQsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXIZQr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:47:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59990 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXIZQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:47:58 -0400
Date: Wed, 26 Sep 2007 18:47:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Kyle Moffett <mrmacman_g4@mac.com>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops
In-Reply-To: <200709261543.l8QFhLC0028883@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709261845110.7066@fbirervta.pbzchgretzou.qr>
References: <200709261543.l8QFhLC0028883@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26 2007 11:43, Erez Zadok wrote:
>
>*That's* the information I was looking for, Kyle: what's the estimated
>probability I should be using as my guideline.  I used 95% (20/1 ratio), and

;-)

19:1 <=> 95:5 <=> 95% <=> ratio=0.95  != 20.0 (=20/1)

>you're telling me I should use 99% (100/1 ratio).  The difference between

99:1 <=> 99% <=> ratio=0.99  != 100.0 (=100/1)

>the number of cycles saved/added is very compelling.  Given that I certainly
>agree with you that I'm using un/likely too much.  I'll re-evaluate and
>update my patch series then.
