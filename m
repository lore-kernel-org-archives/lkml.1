Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbZLOFik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbZLOFik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZLOFif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:38:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42590
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbZLOFic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:38:32 -0500
Date: Mon, 14 Dec 2009 21:38:35 -0800 (PST)
Message-Id: <20091214.213835.160742154.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200E9BC@mi8nycmail19.Mi8.com>
References: <4B241F10.7050706@ru.mvista.com>
	<20091213.205212.212692978.davem@davemloft.net>
	<BD79186B4FD85F4B8E60E381CAEE19090200E9BC@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 14 Dec 2009 12:49:01 -0500

> Based on top of commit 4b7c7237c0826417059d2e60ffe6ed43202dc087

Please don't assume that's the only change that touched this
file.

It isn't and your patch therefore still doesn't apply cleanly.

+ git apply --check --whitespace=error-all diff
error: patch failed: drivers/ide/au1xxx-ide.c:567
error: drivers/ide/au1xxx-ide.c: patch does not apply
