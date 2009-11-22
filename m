Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZKVW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZKVW1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 17:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZKVW1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 17:27:18 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:33236 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZKVW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 17:27:17 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 17:27:17 EST
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Why processes on linux loses signals?
Date: Mon, 23 Nov 2009 01:21:40 +0300
User-Agent: KMail/1.9.9
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
References: <4B09A9CE.4080300@msgid.tls.msk.ru>
In-Reply-To: <4B09A9CE.4080300@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911230121.40885@blacky.localdomain>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In short, processes on linux loses signals.  It happens
> rarely, but it happens, and the frequency of this happening
> is enough to be annoying.
>
> ...
>
> The problem becomes much much worse when a system has multiple
> cores... But with even second core the issue emerges almost
> immediately ...

Looks like a classical race description.
Double-check your user-space code for signal-related races.
