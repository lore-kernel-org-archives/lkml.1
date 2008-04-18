Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYDRLn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYDRLn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 07:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYDRLnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 07:43:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33986 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYDRLnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 07:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aTjDlPaXhaszukUgedhW2HBZX8K4Yhx09lkbhjOOI2+/r1oV6G+fVdmzfLTpwCRfWNdednCQSvm4X7272/++ksac5inVhNLZVI8bn6Lv44chgGxSy/AptRgNd/VumlOZY8sChqiViSCN8fPJe0bYdlGT8RwFcwvS6yp1M/6SHPo=
Message-ID: <e2e108260804180443s429e0db7j3a48056088634ed9@mail.gmail.com>
Date: Fri, 18 Apr 2008 13:43:17 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Unexport of blk_get_queue and blk_put_queue
Cc: "Philipp Reisner" <philipp.reisner@linbit.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Adrian,

I noticed that blk_get_queue and blk_put_queue were unexported in the
2.6.25 kernel. Are you aware that this breaks DRBD (an out-of-tree
kernel module) ?

Bart.
