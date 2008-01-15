Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYAOKsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYAOKsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYAOKrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:47:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57015 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751687AbYAOKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:47:30 -0500
Date: Tue, 15 Jan 2008 10:44:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 5/5] /proc/zoneinfo enhancement
Message-ID: <20080115104406.14ab0da7@lxorguk.ukuu.org.uk>
In-Reply-To: <20080115100233.117E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115100233.117E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 10:03:23 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> show new member of zone struct by /proc/zoneinfo.
> 
> Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Minor NAK - Please put new fields at the end - it makes it less likely to
break badly written tools.
