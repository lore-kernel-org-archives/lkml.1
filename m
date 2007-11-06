Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbXKFMlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbXKFMlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbXKFMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:41:06 -0500
Received: from ozlabs.org ([203.10.76.45]:54105 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbXKFMlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:41:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: Module init call vs symbols exporting race?
Date: Tue, 6 Nov 2007 23:41:34 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <473031FA.2060707@openvz.org>
In-Reply-To: <473031FA.2060707@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711062341.34566.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 November 2007 20:20:58 Pavel Emelyanov wrote:
> Hi.
>
> I looked at the sys_init_module() and found that the ->init callback
> for the module is called without the module_mutex held and *after*
> the module's symbols are exported. Doesn't this create the race when
> loading two modules in parallel? Like this.

Hi Pavel,

	In a word, no.  See "strong_try_module_get()".

Cheers,
Rusty.
