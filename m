Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZFSWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZFSWsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZFSWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:48:04 -0400
Received: from kroah.org ([198.145.64.141]:46293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZFSWsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:48:03 -0400
Date: Fri, 19 Jun 2009 15:44:03 -0700
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
Message-ID: <20090619224403.GA27322@kroah.com>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245450702-31343-1-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:31:21PM -0700, Sage Weil wrote:
> This is a patch series for v0.9 of the Ceph distributed file system
> client (against v2.6.30).
> 
> Greg, the first patch in the series creates an fs/staging/ directory.
> This is analogous to drivers/staging/ (not built by allyesconfig,
> modpost will mark the module with 'staging', etc.), except you can
> find it under the File Systems section (and it doesn't get hidden
> along with drivers/ on UML).
> 
> If that looks reasonable, I would love to see this go into the staging
> tree.  The remaining patches add Ceph at fs/staging/ceph.

No, please put "staging" filesystems at drivers/staging/ where the other
filesystems that are in "staging" shape are.

This is due to some core changes needed to mark such modules as
"TAINT_CRAP", and to make it obvious who is to blame for such crap :)

Care to respin your patches to put the code in drivers/staging/ instead
please?

thanks,

greg k-h
