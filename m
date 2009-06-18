Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZFRROo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZFRROo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZFRROe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:14:34 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44369 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZFRROd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kiSAxC6R6wqQiMScpYAaqdgKcAH3BF8UzN9yMM/6vwDgGZsAwo45nWSVNCZCLRruxb
         023a9W5QpCXcEu3V3QHBHeBYQzMr8mpBSr/WooP2+PXXOMnO5+Pc3DLwoGaXThpxvQsT
         F0cykxieGMjMqsRorXj4eGZuPk58xIykQE7GU=
MIME-Version: 1.0
In-Reply-To: <20090614173331.18f01123@infradead.org>
References: <20090614173331.18f01123@infradead.org>
Date: Thu, 18 Jun 2009 13:08:39 -0400
X-Google-Sender-Auth: 766d2e22d888c492
Message-ID: <b6c5339f0906181008v1cd4b06aof866ea9a91d2eb84@mail.gmail.com>
Subject: Re: kerneloops.org report for the week of June 14 2009
From: Bob Copeland <me@bobcopeland.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@tglx.de, alan@lxorguk.ukuu.org.uk,
       rjw@sisk.pl, netdev@vger.kernel.org, mingo@elte.hu, dwmw2@infradead.org,
       alsa-devel@alsa-project.org, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 8:33 PM, Arjan van de Ven<arjan@infradead.org> wrote:
> Rank 9: minstrel_get_rate (warning)
>        Reported 64 times (384 total reports)
>        Issue with the ath5k driver
>        This warning was last seen in version 2.6.30-rc3, and first seen in 2.6.27.12.
>        More info: http://www.kerneloops.org/searchweek.php?search=minstrel_get_rate

I believe this is fixed by http://lkml.org/lkml/2009/6/5/269, now
in pre-2.6.31.  Hmm, odd though, we should be seeing reports from
other wireless drivers since it's a general memory corruption
unrelated to ath5k (but not all use the mac80211 rate controllers).

(2.6.27.12 must be a backport, minstrel didn't exist until .29)

-- 
Bob Copeland %% www.bobcopeland.com
