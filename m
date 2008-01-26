Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYAZH0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYAZH0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 02:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYAZHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 02:25:58 -0500
Received: from 8bytes.org ([88.198.83.132]:60605 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYAZHZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 02:25:58 -0500
Date: Sat, 26 Jan 2008 08:25:56 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Nakajima, Jun" <jun.nakajima@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to disable NestedPaging
Message-ID: <20080126072556.GB21476@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-4-git-send-email-joerg.roedel@amd.com> <2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D848F959C03D945A84E9EDE7F7BFE4274021D@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 05:47:11PM -0800, Nakajima, Jun wrote:
> Joerg Roedel wrote:
> > To disable the use of the Nested Paging feature even if it is
> available in
> > hardware this patch adds a module parameter. Nested Paging can be
> disabled by
> > passing npt=off to the kvm_amd module.
> 
> I think it's better to use a (common) parameter to qemu. That way you
> can control on/off for each VM.

Generally I see no problem with it. But at least for NPT I don't see a
reason why someone should want to disable it on a VM basis (as far as it
works stable). Avi, what do you think?

Joerg
