Return-Path: <linux-kernel-owner+w=401wt.eu-S933269AbZJNOMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbZJNOMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbZJNOMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:12:23 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:33448
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbZJNOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:12:23 -0400
Message-ID: <4AD5DC1D.9070002@navynet.it>
Date: Wed, 14 Oct 2009 16:11:41 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug on barriers for virtio_blk device - end_request: I/O error, dev
 vda, sector 0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

i ended up with some thiusands of errors after upgrading to 2.6.31.2 
like this one:

end_request: I/O error, dev vda, sector 0
end_request: I/O error, dev vda, sector 0
end_request: I/O error, dev vda, sector 0
end_request: I/O error, dev vda, sector 0

I am using ocfs2 on top of drbd on top of LVM in a KVM guest that uses 
virtio_blk.

The bug is already known, see here:
https://bugzilla.redhat.com/show_bug.cgi?id=514901

A patch exists and the problem has already been submitted here in the list.
See here: http://lkml.org/lkml/2009/8/6/153

That fix is not in 2.6.31 nor in 2.6.32-RCX

Could you please consider pulling it and adding this fix for inclusion 
in 2.6.31.$next and also to mainline?

Thanks.

