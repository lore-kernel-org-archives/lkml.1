Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXLSB6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXLSB6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXLSB6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:58:14 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61262 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXLSB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:58:13 -0500
Subject: Re: [PATCH 1/3] ps3: vuart: fix error path locking
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, kjwinchester@gmail.com
In-Reply-To: <20071218171050.5bf220fa.akpm@linux-foundation.org>
References: <20071213003028.676998182@mvista.com>
	 <4760922C.2060908@am.sony.com>
	 <20071218171050.5bf220fa.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 17:54:48 -0800
Message-Id: <1198029288.2716.25.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 17:10 -0800, Andrew Morton wrote:

> is correct.  Although not exactly a thing of beauty.

This isn't the worst I've seen ;( .. Do you think the ending should fall
through instead of having two returns?

Daniel

