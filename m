Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXKZFqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXKZFqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 00:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXKZFq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 00:46:28 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:52573 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXKZFq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 00:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ubOT7G2ZUM+62Ni9OsMyYGeHZ142IAkTBmWOA/OIGrcqgZu/34rtxHmDwT4+FqlNLtWjnijVlnyRiZT9IMkYGPxRBDataYFuSILchj1kwoYTDxVGhvNkU2vgeXgKmkcFo5aF0iWyEDY5ltCQ+S1g7yGxB6rq8XXNWALIGSn0TXc=
Message-ID: <f69849430711252146q3046d3e1n48c377a18e4e4dfb@mail.gmail.com>
Date: Sun, 25 Nov 2007 21:46:26 -0800
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: profile code added to netif_receive_skb function
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I have added some code to netif_receive_skb function.As linux kernel
is multhreaded , so there is no gaurantee than mine code is completely
executed without being disturbed by any other process .Timer interrupt
handler is an example of code which might interrupt execution of mine
code.

I just want to observe which processes are disturbing mine code .I
think i need to print EIP register values .How can i print cache
contents as well in linux kernel .Are there any tools available for
such purpose


thanks,
shahzad
