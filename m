Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYBZPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYBZPSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYBZPSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:18:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:39073 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYBZPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=d3+sLsEn/sXufipRBPzgcb5RQZGUInZswZ+FA1xBn0I7DJx+DuI7F5uak80q3pJfPBQLR3lWe0P8tw5lK8H17ubbsKfw8STbqZmHZIFZ+/ZP67lbwyG6xaRdFJkVHEmaiRcgmjfUlJhaWFb0OwcrDV29wPaTxIyUmz170R622Dc=
Message-ID: <47C42DDF.3060506@gmail.com>
Date: Tue, 26 Feb 2008 16:18:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>
Subject: [2.6.25-rc2-mm1] Oops in __kmalloc
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while booting up a notebook on 32 bit, this oopses appeared on the console
after ext3 fsck:
http://www.fi.muni.cz/~xslaby/sklad/mem_oops/

It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
issue (unlikely, 2.6.24.2 seems to be OK)?
