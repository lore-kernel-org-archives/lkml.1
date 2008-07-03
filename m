Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYGCVoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYGCVoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757718AbYGCVn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:43:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:49167 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbYGCVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:43:55 -0400
Message-ID: <486D47F1.4080406@infradead.org>
Date: Thu, 03 Jul 2008 22:43:13 +0100
From: David Woodhouse <dwmw2@infradead.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <486D3E88.9090900@garzik.org> <486D4596.60005@infradead.org> <200807032342.01292.rjw@sisk.pl>
In-Reply-To: <200807032342.01292.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Still, maybe we can add some kbuild magic to build the blobs along with
> their modules and to install them under /lib/firmware (by default) when the
> modules are installed in /lib/modules/... ?

Something like appending this to Makefile?

firmware_and_modules_install: firmware_install modules_install

(I'm still wondering if we should make 'firmware_install' install to 
/lib/firmware by default, instead of into the build tree as 
'headers_install' does. The Aunt Tillie answer would definitely be 
'yes', although that means it requires root privs; like modules_install 
does.)

-- 
dwmw2

