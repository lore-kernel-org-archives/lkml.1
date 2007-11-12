Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbXKLD1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbXKLD1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 22:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXKLD1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 22:27:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:21203 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXKLD1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 22:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IEtCG+Id8P1sEHIsQM7hB/TCxuVjjuHq+8qBfytArVWdSrFUY+iHibmYM4ZVS5A86M6xPcM16Z22CWgNCZ2QFCMNc8fT620uc2BJp7dnNhFbyq+5jWRAoxQRx82UtSpF0+uxllC2WT/5ZPtFLj7RoOZPr3naqaSGRhH14HCXdMM=
Message-ID: <4737C81A.5040506@gmail.com>
Date: Mon, 12 Nov 2007 12:27:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Lindroth <thomas.lindroth@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc1: pata_amd fails to detect 80-pin wire
References: <3d08dbff0711070714m32bd0abcg5906fdfe09d633d1@mail.gmail.com> <20071107122100.d203968f.akpm@linux-foundation.org>
In-Reply-To: <20071107122100.d203968f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Cable detection has always been broken for pata_amd.  Recent changes
seem to have broken some other subset tho.  The following patchset to
get it fixed once and for all is pending.

 http://thread.gmane.org/gmane.linux.ide/24524

Thanks.

-- 
tejun
