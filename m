Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYCKRMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYCKRMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYCKRMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:12:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:33818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbYCKRMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:12:37 -0400
Date: Tue, 11 Mar 2008 10:12:16 -0700
From: Greg KH <gregkh@suse.de>
To: stephane eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perfmon x86 infra(take 2): add AMD Northbridge PCI
	Id
Message-ID: <20080311171216.GB26410@suse.de>
References: <7c86c4470803071305x6b575dxa9f7b0588abfd4b@mail.gmail.com> <7c86c4470803110950p54349250pbe29d4122912a2f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470803110950p54349250pbe29d4122912a2f6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 09:50:36AM -0700, stephane eranian wrote:
> Greg,
> 
> Ingo suggested I send ou the following patch which adds a PCI ID
> for AMD Barcelona Northbridge. This is used by the perfmon initialization
> code on this platform.
> 
> Please apply to your tree.

We are trying to not add pci ids that are only used in one place within
the kernel.  Why can't the perfomon init code just add this value to
their code?

Or make this part of the perfmon patch itself, if you really must have
it.  No need to add it to the kernel if there are no in-tree users,
right?

thanks,

greg k-h
