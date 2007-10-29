Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXKAVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXKAVgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXKAVft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:35:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXKAVfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:35:46 -0400
Message-Id: <20071029124120.528997881@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 29 Oct 2007 13:41:20 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [PATCH 0/7] struct path related cleanups of d_path() code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some more struct path cleanups. This patch series changes d_path() to
take a struct path argument. The existing users are changed to give struct path
more deeply into the call chain. In some structures I need to replace existing
<dentry,vfsmount> pairs and embed a struct path instead.

Andreas,
since JJ just posted the AppArmor related d_path() patches I don't include
them here too.

Comments?

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

>>d_path-use_struct_path.diff<<
d_path: Make d_path() use a struct path

>>nfsd-svc_export_use_struct_path.diff<<
Use struct path in struct svc_export

-- 

