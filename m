Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZHYHni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZHYHni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZHYHng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:43:36 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40329 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbZHYHng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:43:36 -0400
Message-ID: <4A939628.6070806@gmail.com>
Date: Tue, 25 Aug 2009 09:43:36 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: checkpatch infinite loop ?
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 25 Aug 2009 09:43:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

Following checkpatch.pl invocation has a problem in current linux-2.6 tree :

scripts/checkpatch.pl --file include/linux/inetdevice.h

linux-2.6.27.10/scripts/checkpatch.pl is OK, but starting from 2.6.28, there is an infinite loop...

Thanks

