Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbXKEQfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbXKEQfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXKEQek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:34:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:39352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbXKEQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:34:39 -0500
Message-Id: <20071105163232.550298985@hasse.suse.de>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 17:32:32 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/9] struct path related cleanups of d_path() code (V2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,
please apply this series to -mm. I just added the seq_file patch, another nfsd
cleanup and changed the patch order.

This patch series changes d_path() to take a struct path argument. The
existing users are changed to give struct path more deeply into the call
chain. In some cases I replaced existing <dentry,vfsmount> pairs and embed a
struct path instead.

Thanks,
Jan


>>one-less-parameter-to-__d_path.patch<<
One less parameter to __d_path

>>d_path-kerneldoc_cleanup.diff<<
d_path: kerneldoc cleanup

>>d_path-Use_struct_path_in_struct_avc_audit_data.diff<<
d_path: Use struct path in struct avc_audit_data

>>d_path-Make_proc_get_link_use_a_struct_path_argument.diff<<
d_path: Make proc_get_link() use a struct path argument

>>d_path_Make_get_dcookie_use_a_struct_path_argument.diff<<
d_path: Make get_dcookie() use a struct path argument

>>nfsd-svc_export_use_struct_path.diff<<
Use struct path in struct svc_export

>>nfsd-svc_expkey_use_struct_path.diff<<
Use struct path in struct svc_expkey

>>d_path-Make_seq_path_use_a_struct_path_argument.diff<<
d_path: Make seq_path() use a struct path argument

>>d_path-use_struct_path.diff<<
d_path: Make d_path() use a struct path


