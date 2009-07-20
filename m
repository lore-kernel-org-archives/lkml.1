Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZGTQdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZGTQdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZGTQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:33:31 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:63985 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZGTQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xn3nIFyuOVGu2z1MlcFUdPV1cteOoNcfHWyjdkhUUCqES7hMRmDz5nsmzp0h5Vcrfy
         lMqghLuc5xDSuI3hxgare2HRx6ysRkHSCYPRtjJoNt/W1D2LooQq/sKUMF6F7fxgPZHM
         kv834qQ3q64COryYgHrUgEbrH8PJfol6Av6NQ=
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 17:33:29 +0100
Message-ID: <87a5b0800907200933m2620c872reab268246ad896cf@mail.gmail.com>
Subject: flush_icache_user_range
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

flush_icache_user_range is defined for a number of architectures but
is not used anywhere as far as I can tell. It's also not in the
feature removal schedule or other documentation.

Should it be removed? Should new ports implement this interface?

Thanks,
