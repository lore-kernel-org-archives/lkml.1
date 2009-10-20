Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZJTFrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZJTFrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZJTFri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:47:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49366 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZJTFrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:47:37 -0400
Date: Mon, 19 Oct 2009 23:47:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH 0/3] Allow sysfs to be dynamically populated
Message-ID: <20091020054740.GC29158@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first patch in this series is just a bugfix.

The second and third patches offer progressively more flexibility to
dynamically construct the contents of sysfs directories.  The second
patch delays the allocation of sysfs_dirents until the contents of
the directory is requested.  This functionality is only used by the
attribute_groups in that patch, but could (in principle) be extended to
other directory providers.

The third patch extends this to permit attribute groups to be dynamically
constructed before the directory they're in is populated.  I also add a
user for this; the much-requested ability to display the MSI-X vectors
in use by a device.

Both patches also deconstruct the directories / attribute groups when the
dentry of the directory goes out of cache.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
