Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbZCSSLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbZCSSLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZCSSJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:09:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60980 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbZCSSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:09:30 -0400
Date: Thu, 19 Mar 2009 12:09:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] PCI: Introduce pci_rescan_bus()
Message-ID: <20090319180912.GB14127@parisc-linux.org>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318223956.887.57080.stgit@bob.kio> <20090319022735.f24b7329.akpm@linux-foundation.org> <20090319170548.GE8074@ldl.fc.hp.com> <20090319174215.GB26248@kroah.com> <20090319174938.GJ8074@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319174938.GJ8074@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 11:49:38AM -0600, Alex Chiang wrote:
> I went over and ran it on all my patches, and that was indeed one
> of the complaints.
> 
> But when it comes to file consistency vs "letter of the law" I
> like to keep things consistent (even if broken) in the file.
> 
> I could go back and move all those EXPORT_SYMBOL declarations to
> the "proper" place. Is that too much noise though?

The accepted way to do this is to add a prep patch which just fixes the
checkpatch warnings (ie moves the EXPORT_SYMBOLs).  Then your patch is
all shiny and fresh.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
