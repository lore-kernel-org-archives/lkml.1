Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYCBMLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYCBMLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 07:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYCBMK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 07:10:58 -0500
Received: from userg501.nifty.com ([202.248.238.81]:44439 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYCBMK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 07:10:58 -0500
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=M0GSQPCgVvPe/4EBdrKrRhnLjRRMccGfBq4srMTMSazbbal9M3sNurajhHs/ZxTmY
	Y9sQk9dwBf9cVfg7EZlSA==
X-Nifty-SrcIP: [222.159.205.91]
Date: Sun, 2 Mar 2008 21:07:16 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG  kernel 2.6.25-rc3  IPV6]  ping6 -I eth0 ff02::1 causes system
 hang.
Message-Id: <20080302210716.69727582.komurojun-mbn@nifty.com>
In-Reply-To: <20071014073658.d4352b8c.komurojun@nifty.com>
References: <20071006132601.f944f461.komurojun@nifty.com>
	<20071014073658.d4352b8c.komurojun@nifty.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On kernel 2.6.25-rc3, IPV6 multicast ping causes system hang
after sending several multicast ping packet.

>ping6 -I eth0 ff02::1 

This problem does not happen on kernel 2.6.24.
(does not depend on NIC)


Best Regards
Komuro


