Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXLFCP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXLFCP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 21:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXLFCOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 21:14:22 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1845 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbXLFCOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 21:14:20 -0500
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jengelh@computergmbh.de, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071205160133.0766c4f5.akpm@linux-foundation.org>
References: <1196359724.22120.22.camel@localhost>
	 <20071129102400.dac158d8.randy.dunlap@oracle.com>
	 <1196361860.22120.27.camel@localhost> <474F0A68.1080809@oracle.com>
	 <1196369873.22120.69.camel@localhost> <474F28EB.20608@oracle.com>
	 <Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>
	 <1196378922.22120.72.camel@localhost>
	 <20071205160133.0766c4f5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 18:10:16 -0800
Message-Id: <1196907017.10819.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 16:01 -0800, Andrew Morton wrote:
> You could trim linebuf[] to 80 chars or so.  Extra points for making it
> very clear when someone tries to exceed that - strcpy(linebuf, "stop being
> stupid").

Maybe just eliminate the 16 or 32 byte width option and
force it to only 16 byte widths.

That'd keep it down to ~ 100 bytes nicely.

Prefix + address + dump + ascii: 20 + 18 + 48 + 10.

