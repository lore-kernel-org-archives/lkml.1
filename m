Return-Path: <linux-kernel-owner+w=401wt.eu-S2992663AbXCGWXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992663AbXCGWXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992476AbXCGWXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:23:10 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:51976 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992663AbXCGWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OlQ7mYF0R+stoYRuggXgysgu0iTOo+zi8ROgvMT53TdsmNAbydkjXfx7nnUOd5L/lbQkVU/Ln03LuyvcO4R9STZl68WYTDda1J9N8bSU9QPpiZYRoiZLBIIScWso8KfBs4X7MUnIiL6WxnJKqgfELFd6pdtlRG9883mi5q2l/LU=
Message-ID: <d120d5000703071423n11ade9d7n1852296d70b53d62@mail.gmail.com>
Date: Wed, 7 Mar 2007 17:23:05 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: chrdev_open lifetime question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that if a process keeps a character device open then other
processes will also be able to get into filp->f_op->open(inode,filp)
in chrdev_open() even after a driver called cdev_del() as part of its
unwind procedure. Is this correct or am I missing something?

Thanks!

-- 
Dmitry
