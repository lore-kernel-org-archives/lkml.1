Return-Path: <linux-kernel-owner+w=401wt.eu-S1030280AbXCLOvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280AbXCLOvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030299AbXCLOvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:51:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:33016 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030280AbXCLOvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CSkD1+KimRevj8eNMqziVUxCXpBLo9DXWPlwNewsx6veXMup285ZbJvX7SLXFIpnYsag5HjzD48j+4lbVA9TZpAbilvTx2oa941GJdJ0tq3DH5pgrS8fUqRiP0Xn7Vpr6RIFvxkpiC4sAtMJKsA4CyZusDD52BA+Jj4kjh9OCT8=
Message-ID: <45219fb00703120751t7acd1ae3kb77f556b81a87634@mail.gmail.com>
Date: Mon, 12 Mar 2007 15:51:19 +0100
From: "=?ISO-8859-1?Q?Llu=EDs_Batlle?=" <viriketo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: bug in select() in linux
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've found a problem in the select() call. The manpage states:
"those in writefds will be watched to see if a write will not block"

I've tried a select() for write against a closed tcp socket (closed by
the other side), and the select call _blocks_.

Any write() call to that socket will _not block_, and will return with EPIPE.

I've seen this happening in 2.4.20 and 2.6.16.29 (xen patched) at least.

Maybe it's a glibc problem - you may know better.

Could you please keep me in carbon copy? I'm not sure I want to
subscribe to LKML.

Regards,
Lluís.
