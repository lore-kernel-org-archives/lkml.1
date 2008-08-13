Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYHMF7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYHMF7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYHMF7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:59:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35147
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbYHMF7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:59:23 -0400
Date: Tue, 12 Aug 2008 22:59:24 -0700 (PDT)
Message-Id: <20080812.225924.62357936.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] x86: use the new byteorder headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080812225612.6742aaf0.akpm@linux-foundation.org>
References: <1218587234.30194.93.camel@brick>
	<20080812225612.6742aaf0.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Aug 2008 22:56:12 -0700

> I'll drop them all.  Do you have a cross-compiler suite there?

I think Harvey needs a mentor which can help him learn how to properly
build validate his patches before he submits them, and how to not mix
things up by, for example, validating the build with patches applied
that won't be submitted etc.

Every time I integrate these byteorder patches directly for networking
or sparc, it tends to be a build regression nightmare.

I think Andrew has hit 3 already with this patch series, quite an
accomplishment.  :-/
