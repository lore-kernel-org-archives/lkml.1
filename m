Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYABKDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYABKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 05:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYABKDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 05:03:43 -0500
Received: from namei.org ([69.55.235.186]:40218 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752926AbYABKDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 05:03:42 -0500
Date: Wed, 2 Jan 2008 21:02:23 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: KaiGai Kohei <kaigai@kaigai.gr.jp>
cc: KaiGai Kohei <kaigai@ak.jp.nec.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@osdl.org, morgan@kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Exporting capability code/name pairs
In-Reply-To: <477B457E.6000802@kaigai.gr.jp>
Message-ID: <Xine.LNX.4.64.0801022100550.30212@us.intercode.com.au>
References: <477321C8.3070004@ak.jp.nec.com> <20071227161435.GB9677@sergelap.austin.ibm.com>
 <477455A0.7060603@ak.jp.nec.com> <477494C3.2040301@ak.jp.nec.com>
 <Xine.LNX.4.64.0712281957520.23510@us.intercode.com.au> <477B457E.6000802@kaigai.gr.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, KaiGai Kohei wrote:

> > Another issue is that securityfs depends on CONFIG_SECURITY, which might be
> > undesirable, given that capabilities are a standard feature.
> 
> We can implement this feature on another pseudo filesystems.
> Do you think what filesystem is the best candidate?
> I prefer procfs or sysfs instead.

Sysfs makes more sense, as this information is system-wide and does not 
relate to specific processes.


-- 
James Morris
<jmorris@namei.org>
