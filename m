Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZAMOF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZAMOF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZAMOFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:05:47 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53938 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZAMOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Cedjk5vDjbtRdjhsFE+6vumV5ulLZVNrND5KVNPpaftF9HflJCIclBi4T8z3JZkIMt
         52fHoDtagf3PZ1m8eI8CfUXVqxb0VfeNdCxM4ioblOO+PE8vBLfp7GGHjO0zHhGFGRlt
         U4qpl+qAiY1LlnWJLzuLxf7aYJW5qUDRj/p2w=
Message-ID: <1837b62c0901130605q12769960h8fc61d3cf878609a@mail.gmail.com>
Date: Tue, 13 Jan 2009 15:05:44 +0100
From: "Tomasz Turski" <turtomek.ey@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: vfs and permission() locking policy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to know what is the locking policy in permission() function
in vfs (in file fs/namei.c).
I would like to lock inode->i_mutex in permission(), but I don't know if
I don't have any deadlock.

Regards,
Tomasz Turski
