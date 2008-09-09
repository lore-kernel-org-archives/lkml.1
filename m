Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYIIJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYIIJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYIIJcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:32:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:21419 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYIIJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qJ3BDnweyGb0guZgokD34877KLWHlSC3IjbPOLKhZIrdbIGBABch5lnPmbl2jTIUSN
         pG2OH9KOmAA/HJUvCPBGS+ESCMIDMDRFF5MHZofHMt3imfsnhJYqEOVSg8FsJegrnL8h
         C6jgpxuYUHytyJgd08f3iyka4HPOSLUcHpRnA=
Message-ID: <48C6429A.1040809@gmail.com>
Date: Tue, 09 Sep 2008 11:32:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: mmotm 2008-09-08-18-32 uploaded
References: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
In-Reply-To: <200809090135.m891ZHiW020337@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napsal(a):
> The mm-of-the-moment snapshot 2008-09-08-18-32 has been uploaded to

Hi,

CONFIG_MII=n
CONFIG_R8169=y

causes:
drivers/built-in.o: In function `rtl8169_gset_xmii':
r8169.c:(.text+0x8b4ec): undefined reference to `mii_ethtool_gset'

R8169 should depend on MII?
