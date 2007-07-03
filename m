Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXGCF3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXGCF3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXGCF27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:28:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:54491 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXGCF27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R2P2iWINgeJID2+TjOQ+6VGNX1jUiV6QeVreU/rN7w5qkQ2n8vhLjESzpWJLr5sPr14f0cxf7oRkDJwjkz8mrwKfJrzE5I/ps+FgBA2w+FkT1lPhhh+44cpML38yGqafw7JI2RB9Zt+ZySkpJsZZyDQmWC7E/FQI1k81TMgm2MI=
Message-ID: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
Date: Tue, 3 Jul 2007 01:28:57 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: how do versioning filesystems take snapshot of opened files?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


If a file is already opened when snapshot command is issued,  the file
itself could be in an inconsistent state already. Before the file is
closed, maybe part of the file contains old data, the rest contains
new data.
How does a versioning filesystem guarantee that the file snapshot is
in a consistent state in this case?

I googled it but didn't find any answer. Can someone explain it a little bit?

Thanks
