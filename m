Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYHNTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYHNTzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYHNTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:55:33 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:58449 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYHNTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BCpPlXPHYzHceOPaBy15VBfI9PiO8CrV40nPrLNSCpGz4+TxLGltGQnHoGAS9ayxEx
         3w1/N6kJjUIEN5SileSnuk02gklDJY4cL/s5okjpzQq8S4IbuHhAha9wFQKJrqaHxdYa
         bu/QdqwITaLHI2ghcYixvwrmH9C6C9Rt4oVEg=
Message-ID: <6278d2220808141255g75618548qa7381e5569805646@mail.gmail.com>
Date: Thu, 14 Aug 2008 20:55:31 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Lachlan McIlroy" <lachlan@sgi.com>
Subject: [2.6.27-rc3] XFS logbsize/logbufs option problem...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the logbsize (eg =256k) or logbufs (eg =8) XFS mount options are
present in /etc/fstab, the filesystem fails to mount r/w with
2.6.27-rc3, so stays read-only.

This seems to be a regression over 2.6.27-rc1 (didn't check -rc2). I'm
testing on Ubuntu Intrepid x86-64, thus filesystem was constructed
with xfsprogs 2.9.8-1.

Have you seen encountered this issue at all?

Many thanks,
  Daniel
-- 
Daniel J Blueman
