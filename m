Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYIWGu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYIWGu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYIWGuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:50:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:53047 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYIWGuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:50:14 -0400
Date: Tue, 23 Sep 2008 16:48:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
In-Reply-To: <20080922215032.GB502@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0809231610530.25628@tundra.namei.org>
References: <20080922184835.GA2826@us.ibm.com> <1222110964.18735.77.camel@moss-spartans.epoch.ncsc.mil> <200809222209.37218.agruen@suse.de> <20080922215032.GB502@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008, Serge E. Hallyn wrote:

> > I agree. These other behaviorial changes should not depend on 
> > CONFIG_SECURITY_FILE_CAPABILITIES; the old behavior should just be fixed 
> > instead.
> 
> That of course would be the point of the patch 3/3, which removes
> CONFIG_SECURITY_FILE_CAPABILITIES as a config option.

btw, don't make it Y at all (patch 1/3 ?), as Linus has outlawed making 
new features default to Y.

>  Should I do that when I redo the patch as per Stephen's suggestion to 
> use filecaps=0/1?

Given that there's existing use of no_file_caps, and that I doubt Fedora 
will provide an install option to disable it, probably just stick with 
no_file_caps.


- James
-- 
James Morris
<jmorris@namei.org>
