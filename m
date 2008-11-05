Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYKEHaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYKEHaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKEH3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:29:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49833
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbYKEH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:29:45 -0500
Date: Tue, 04 Nov 2008 23:29:20 -0800 (PST)
Message-Id: <20081104.232920.150683916.davem@davemloft.net>
To: mchan@broadcom.com
Cc: linux-kernel@blueteddy.net, daniel.blueman@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: David Miller <davem@davemloft.net>
In-Reply-To: <C27F8246C663564A84BB7AB343977242151F4B18B4@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <20081104.215839.132524253.davem@davemloft.net>
	<C27F8246C663564A84BB7AB343977242151F4B18B4@IRVEXCHCCR01.corp.ad.broadcom.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Tue, 4 Nov 2008 22:31:00 -0800

> Assuming ECE and CWR are set infrequently on TSO frames, we still
> benefit from hardware TSO most of the time.  Why is it the wrong
> thing to do?

I had forgotten about that aspect, and yes this is a
good tradeoff considering that.
