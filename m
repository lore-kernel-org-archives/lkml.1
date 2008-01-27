Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbYA0XSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbYA0XSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYA0XSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:18:42 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:10055 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYA0XSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uZja4Nq8go74MEFcCPYJxaXYA/7qrstIvBzcgOvEE6RdpKdhIxwYOxb8uSfOr6PxflFiPlu76uVTYG4zsdT3Dl3e+gh4TJdBl6xb3k33dvLAgHMKenCq1sP+QH7CEmWuYtDq3YpP826t4GvMChDSLR09LJ6CmTQRGMwLpTdEqqM=
Message-ID: <b6a2187b0801271518g7b9b4432h87a06774fce2565c@mail.gmail.com>
Date: Mon, 28 Jan 2008 07:18:40 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, cups-bugs <cups-bugs@easysw.com>
Subject: cups slow on linux-2.6.24
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sending printing jobs to a network printer (it's actually printing
to the localhost simply creating a file), and running this on
Linux-2.6.24 will cause the printing to slow down to 1 print every 3
seconds after printing 500 times.

No such symptoms on 2.6.23.12, or 2.6.20.21.

It's repeatable.

I'm just check if this is already reported/resolved before bisecting the kernel.

Thanks,
Jeff.
