Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZLUVns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZLUVns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZLUVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:43:48 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:56842 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZLUVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:43:47 -0500
Message-ID: <4B2FEC10.6050900@msgid.tls.msk.ru>
Date: Tue, 22 Dec 2009 00:43:44 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
CC: alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
References: <200912211643.18173.tvrtko.ursulin@sophos.com>
In-Reply-To: <200912211643.18173.tvrtko.ursulin@sophos.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
> Hi,
> 
> When run under VMware, LZMA compressed 2.6.33-rc1 instantly reboots in the 
> decompression stage. At least I suppose so, because switching to GZIP makes 
> it work.

Switch /bin/sh from dash to bash and recompile (actually relink) - it should work.

/mjt
