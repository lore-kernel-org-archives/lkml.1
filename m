Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZJBHMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZJBHMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbZJBHMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:12:46 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:63613 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbZJBHMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JaGbVcquBgWZlUoIdaKm2BMbxRJtm73MD0/dbmyikZlXUL6yIy1gQL4DRR3p+HqGir
         RaMyjpI0ANOKnAwWcW2rwux2N0TVPgk/4K1WF7u9VPLsy4qVJgsOJOoleVQ5IlI5pvV0
         Txg9CTzBfUiR11TMM7q3l88Wuhq/zNmeTa0fY=
MIME-Version: 1.0
In-Reply-To: <COE24pZSBH.A.A5C.VOTxKB@chimera>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <COE24pZSBH.A.A5C.VOTxKB@chimera>
Date: Fri, 2 Oct 2009 09:12:48 +0200
Message-ID: <b637ec0b0910020012n57e110cbl180aa5bda318e5d5@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I suppose this is still valid. I had to work around it by rfkill-ing
the device during the suspend process and reenabling at resume time.

I can try to reproduce it with 2.6.31.1 if you want it.

On Thu, Oct 1, 2009 at 9:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-08-06 20:15 (57 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
