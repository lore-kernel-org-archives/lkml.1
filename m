Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0BDXbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:31:13 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:52390 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0BDXbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ngxoLwEPeoqNxnq4dJyYyOAcjLz6V/b02acAMNrTa/usnks3xzf3lBhpbxwKw2eROj
         KfUAfv5mqZv/FyiQpqNtcW2WX73u3mrd7GgglWplaCViy7Oo7ybcz4UREgl68ht8HUmj
         WJhgiL/LddKcaHBFggxBGxFJv2cmBmy5kb/zI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V6] Work to enable SmartMedia/xD support
Date: Fri,  5 Feb 2010 01:30:40 +0200
Message-Id: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version fixes few bugs I discovered, especially
place where I forgot to unlock a mutex, another mistake in suspend/resume code
that prevented driver from working if card was removed during low power state.

David, merge window will soon open, so could you somehow review this?

Best regards,
	Maxim Levitsky

