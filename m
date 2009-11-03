Return-Path: <linux-kernel-owner+w=401wt.eu-S1753618AbZKCNPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbZKCNPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZKCNPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:15:45 -0500
Received: from www.tglx.de ([62.245.132.106]:34725 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZKCNPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:15:44 -0500
Date: Tue, 3 Nov 2009 14:15:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: linux-kernel@vger.kernel.org, Jon Masters <jcm@redhat.com>,
       linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH -rt]
 Updates-from-Jon-Masters-for-hwlat_detector.c.patch
In-Reply-To: <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0911031413230.12138@localhost.localdomain>
References: <alpine.LFD.2.00.0910230007030.3737@localhost.localdomain>  <alpine.LFD.2.00.0911021620580.12138@localhost.localdomain> <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, John Kacur wrote:
> Updated patch just adds the error checking from Jon Masters then,
> patched against -rt.

Can you please inline patches ?

@@ -607,7 +607,11 @@ static ssize_t  debug_enable_fwrite(stru
 		if (!enabled)
 			goto unlock;
 		enabled = 0;
-		stop_kthread();
+		err = stop_kthread();
+		if (0 != err) {

	Eeew !	

Thanks,

	tglx
