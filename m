Return-Path: <linux-kernel-owner+w=401wt.eu-S1764180AbYASBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180AbYASBQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYASBQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:16:13 -0500
Received: from ns.suse.de ([195.135.220.2]:33642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759707AbYASBQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:16:12 -0500
Date: Sat, 19 Jan 2008 02:16:09 +0100
From: Andi Kleen <ak@suse.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 1/10] add missing parameter for lookup_address
Message-ID: <20080119011609.GA15614@bingen.suse.de>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <20080118202613.GY3627@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118202613.GY3627@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:26:13PM -0800, Chris Wright wrote:
> * Glauber de Oliveira Costa (gcosta@redhat.com) wrote:
> > lookup_address() receives two parameters, but efi_64.c call
> > is passing only one. It's actually preventing the tree from compiling
> > 
> > Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> 
> Good catch, I know I don't test with CONFIG_EFI=y

Ah that came probably from the CPA patchset which added the parameter.
Sorry for that.

-Andi
