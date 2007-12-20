Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXLTTc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXLTTc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXLTTct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:32:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:35179 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXLTTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:32:49 -0500
Subject: Re: [PATCH 1/3] ps3: vuart: fix error path locking
From: Daniel Walker <dwalker@mvista.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, kjwinchester@gmail.com
In-Reply-To: <47688A5A.1090902@am.sony.com>
References: <20071213003028.676998182@mvista.com>
	 <4760922C.2060908@am.sony.com>
	 <20071218171050.5bf220fa.akpm@linux-foundation.org>
	 <47688A5A.1090902@am.sony.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 11:32:25 -0800
Message-Id: <1198179145.10713.9.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-18 at 19:04 -0800, Geoff Levand wrote:

> Unfortunately there wasn't enough context in the patch to see
> that there is a down() earlier in the routine, and that the patch
> does indeed remove an incorrectly placed down().  Here is the
> entire routine, marked with what the patch removes.
> 

Andrew have you had a chance to review this?

Daniel

