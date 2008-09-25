Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbYIYBhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbYIYBhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYIYBhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:37:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:56091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYIYBhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:37:05 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 2/2] file capabilities: remove CONFIG_SECURITY_FILE_CAPABILITIES
Date: Thu, 25 Sep 2008 03:36:27 +0200
User-Agent: KMail/1.9.9
Cc: Chris Wright <chrisw@sous-sol.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <randy.dunlap@oracle.com>
References: <20080924020432.GA25997@us.ibm.com> <20080924234857.GA22375@sequoia.sous-sol.org> <20080925010233.GB7324@us.ibm.com>
In-Reply-To: <20080925010233.GB7324@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250336.27647.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 25 September 2008 3:02:33 Serge E. Hallyn wrote:
> Quoting Chris Wright (chrisw@sous-sol.org):
> > What is being done to enable userspace in distros to make those 570
> > bytes generally useful?
>
> Fedora 9 and ubuntu intrepid already have full capabilities support and
> modern libcap.  Sles is set to ship with a modern libcap, and according
> to what Andreas is saying, if we can provide them with the no_file_caps
> boot option then suse is willing to have a kernel with capabilities
> turned on.

Yes.

> I think gentoo still comes with libcap-1.  Need to look into 
> changing that.
>
> I suppose the next baby-step will be to do get rid of setuid on little
> things like ping.

Real file capability support in RPM seems important to me; hacking this 
into %post scripts is not a reasonable approach.

Thanks,
Andreas
