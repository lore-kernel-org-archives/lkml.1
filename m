Return-Path: <linux-kernel-owner+w=401wt.eu-S1765371AbXHGORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765371AbXHGORr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXHGORi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:17:38 -0400
Received: from namei.org ([69.55.235.186]:48384 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754646AbXHGORi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:17:38 -0400
Date: Tue, 7 Aug 2007 07:17:15 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: clear fcaps on inode change (v2)
In-Reply-To: <20070807140827.GB8286@sergelap.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0708070716380.28521@us.intercode.com.au>
References: <20070806185231.GA21550@sergelap.austin.ibm.com>
 <Pine.LNX.4.64.0708070640160.31104@us.intercode.com.au>
 <20070807140827.GB8286@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007, Serge E. Hallyn wrote:

> Shall I resend without the LSM_NEED_LOCK, or do you still want a more
> fundamental change?


Removing the needlock is enough, the rest was just a query/suggestion.


-- 
James Morris
<jmorris@namei.org>
