Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZAJLDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZAJLDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZAJLCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:02:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:37303 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZAJLCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=tqExpNiXeTtrkA4UYeb1to2m4O1aGX0tTZjF7FHUFiJLpp1IBuPWvJzoj/WfkkYMlD
         Yp0xYXFcfEqKTljNV73IbS0OCj2vnsb2aaAg4Wcwffjel9HcGhkzx+4Th0ApsxXm6KJB
         fiEHD9lvP37jezhwkn6gkFSZzqeith/CZL9NY=
Message-ID: <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
Date: Sat, 10 Jan 2009 20:02:54 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] add b+tree library
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
In-Reply-To: <1231584446.3685.21.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231584446.3685.21.camel@johannes>
X-Google-Sender-Auth: ac20f12236fee4f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> This adds a b+tree library. The API and memory layout is documented in
> the header file lib/btree.h. There are tree versions for 32, 64 and
> 128 bit keys as well as unsigned long (32/64 depending on platform).

Can this library remove the btree code in some btree based filesystem?
