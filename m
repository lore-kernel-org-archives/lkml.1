Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXKNDlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXKNDlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbXKNDlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:41:44 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:37600 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761117AbXKNDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rmtEQ2Bjz2LG5EH5PWsavjet8ipEpsu8qp5E9dPGaFlF+Q7SAD6HLRVNu/JiZpJSt2s6iTasw3+INTDjN5kg5rhiBMpUAFrBTuD8JgnP5aaGS3JWvPsLhQmdoq21fiI2x1Axlz+akTaTbnIj/X+nu7pEkKqIiaqF7TgQTtw1h0s=
Message-ID: <473A6E72.60503@googlemail.com>
Date: Wed, 14 Nov 2007 04:41:38 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uff clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch *really* spams.
Looks like some programs are using this 'deprecated flag'. 

Could this have some CONFIG_SPAM_ME_PLEASE ?;)

This is what I got in some minutes :


--dmesg|grep 'used deprecated clone flags'|sed 's/.*] //'|sort -u
fork(): process `artsd' used deprecated clone flags 0x400000
fork(): process `firefox-bin' used deprecated clone flags 0x400000
fork(): process `gcompris' used deprecated clone flags 0x400000
fork(): process `qgit' used deprecated clone flags 0x400000
fork(): process `thunderbird-bin' used deprecated clone flags 0x400000
fork(): process `wish' used deprecated clone flags 0x400000
fork(): process `xchat' used deprecated clone flags 0x400000
fork(): process `kdbus' used deprecated clone flags 0x400000

--dmesg|grep 'used deprecated clone flags'|wc -l
151


Gabriel

