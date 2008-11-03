Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYKCXGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYKCXGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYKCXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:06:45 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:26599 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752800AbYKCXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:06:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IN6XX1wIyPzuVWEHuGhJufe0FGOl8ffH8SdXq/9teOxlFEY0H1cfsN0m12eMVAUtiQVaXi8zMDwvdFSmilMsqQTbYcVwy9TTuUVkajXN7PeC1YBKtaoQKFA7jnSzzStT5faeDEya/HJAKwxFPdXDOqm4oJJzRhsEdCy1maPw4dk=  ;
X-YMail-OSG: AT.3Y9QVM1nD9qV_y7CoOxDID6lakIdRI6kNe6KY_ITQ_c9GXveCAqITI.h0JBP3voZIBv05xzmLCyGUOTxALPdhoQuSSoLj.2H8iuUC1yh4gfwLwLE6pisq3TEGYfg1jSF_5OBWbpMIB5QG6gzQugJR
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH] rtc-cmos: Fix boot log message
Date: Mon, 3 Nov 2008 16:06:41 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200811031942.20360.elendil@planet.nl> <200811031952.39423.elendil@planet.nl>
In-Reply-To: <200811031952.39423.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811031506.42247.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 November 2008, Frans Pop wrote:
> Alternative would be to change the following line at 808:
>                         is_hpet_enabled() ? ", hpet irqs" : "");
> to:
>                         is_hpet_enabled() ? "hpet" : "<sensible value>");

The intent was "hpet irqs" vs "native IRQs" (typical PC options)
vs "no irqs" (e.g. on SPARCs).

I think fixes got trashed when the patch queue got corrupted
by some queue-jumping ... see the patch in 

  http://bugzilla.kernel.org/show_bug.cgi?id=11153

which was broken by a474aaedac99ba86e28ef6c912a7647c482db6dd,
and has appropriately sane messaging.

- Dave



