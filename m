Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbZDCAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbZDCAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZDCAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:24:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:50488 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZDCAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u2HK/WDKggY12edRum87RJM6OEKJaYgjznQI7s5uakSaYD/owF6Q6rtO8Y7Jq2oVBX
         RfDfUDIBIsYSF8xs+6Kf/WBwcPZ7urriNx/i+JNM01POKboczXChRiq5wKLmfPwiwWxS
         HzpeFy83MbFSX8eBBNb2+klyAH4SK8EDQUME8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
Date: Thu, 2 Apr 2009 18:24:06 -0600
Message-ID: <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 6:09 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Fri, 27 Mar 2009, Artem Bityutskiy wrote:
>> They just say - this is file-system bug, it is fixed in
>> ext4 now, just fix the bug in UBIFS.
>
> Would *mounting* the filesystem with "-o sync" help? This way no
> filesystem "fixes" are needed and userland would not have to be rewritten.
>
> Christian.

Yes, mounting "-o sync" does improve ext3 performance.  It sucks
though, because I do want quick writes.  And mounting with sync option
slows down to disk io speeds.  In my case, that's between 20 and 23
megabytes per second *big frown, quivering lip, and tears in my eyes*.
:P
