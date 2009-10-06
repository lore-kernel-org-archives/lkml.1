Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbZJFW2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbZJFW2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbZJFW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:28:21 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60811 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933558AbZJFW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=BhEqmhOwC2uD2ZVk606BFSoIFfDxe/udcf6qafDfISYgEusNn7YYlEHw1imgSOQx8C
         VQSaqhu68pO8SkmZ7U6q0SOVy4jJr+4rACaQq6VQ0x1Rw4adW94TyFU/nuRpX9Vs6SoS
         E7oSNa/Su26gQk0by+7Y0XwmfbiOuoUKzw2PQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] two ide fixes for -rc4
Date: Wed, 7 Oct 2009 00:27:30 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <200910070027.30377.bzolnier@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, d.stussy@yahoo.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patch #1 fixes old bug in sis5513 (uncovered by 2.6.30 device probing
changes but it could be also triggered in earlier kernels on warm-plug
operation)

patch #2 reverts the recent incorrect revert
