Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXHSXFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXHSXFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXHSXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 19:05:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1612 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbXHSXF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 19:05:28 -0400
Subject: Re: convert #include "linux/..." to #include <linux/...> [PATCH]s
	follow
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
References: <1187561864.4200.136.camel@localhost>
	 <Pine.LNX.4.64.0708200031560.19577@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 16:05:23 -0700
Message-Id: <1187564724.4200.170.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 00:33 +0200, Jan Engelhardt wrote:
> Not only that. All directories in include should be checked against
> (e.g. <net/*>)

Should any file in include/ have a line like:

	#include "[path/]file"

Shouldn't these all be

	#include <path/file>

?

