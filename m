Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZBIGcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZBIGcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZBIGcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:32:24 -0500
Received: from ozlabs.org ([203.10.76.45]:55103 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZBIGcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:32:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] module: create a request_module_nowait()
Date: Mon, 9 Feb 2009 17:02:17 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, mchehab@infradead.org
References: <20090208104201.6124ab6a@infradead.org>
In-Reply-To: <20090208104201.6124ab6a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091702.18887.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 05:12:01 Arjan van de Ven wrote:
> This patch changes this to use a request_module_nowait() function macro instead,
> which just fires the modprobe off but doesn't wait for it, and thus avoids the
> original deadlock entirely.

Nice, applied.  Made one change; I've taken to using the new-fangled bool
type for flag args, for slight extra clarity.

(Which uncovered another interesting issue, which lead to several more
 patches).

Thanks,
Rusty.

