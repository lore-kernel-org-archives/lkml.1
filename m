Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYIVWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYIVWJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYIVWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:09:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:46297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYIVWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:09:04 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
Date: Tue, 23 Sep 2008 00:08:30 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
References: <20080922184835.GA2826@us.ibm.com> <200809222209.37218.agruen@suse.de> <20080922215032.GB502@us.ibm.com>
In-Reply-To: <20080922215032.GB502@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809230008.31025.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 September 2008 23:50:32 Serge E. Hallyn wrote:
> Quoting Andreas Gruenbacher (agruen@suse.de):
> > I agree. These other behaviorial changes should not depend on
> > CONFIG_SECURITY_FILE_CAPABILITIES; the old behavior should just be fixed
> > instead.
>
> That of course would be the point of the patch 3/3, which removes
> CONFIG_SECURITY_FILE_CAPABILITIES as a config option.  Should I
> do that

I think yes.

> when I redo the patch as per Stephen's suggestion to use filecaps=0/1?

This will require to adjust our installer, which uses no_file_caps already. I 
don't think that filecaps=0/1 is really necessary, but it I can life with 
either.

Thanks,
Andreas
