Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZCUFrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZCUFrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZCUFqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:46:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14565 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZCUFqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=p4VHn6EpgBCTHBZ1mUwFBpoyN2HYCrD4uJ/2+Qbms0A/ISkiR5mR4l7QxhyWVDwhQD
         WBqHJnjoHyd9F+irDTI9jDkHiMTea3sioOztvcO1w8f0xr0KHU2hE+A4IrAVgBMSsXep
         ozec0wbTlphU+GqcofJSgiBMZVI0mZ5E8De78=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan Opmeer <arjan@opmeer.net>
Subject: Re: [PATCH] input: elantech.c provide a workaround for jumpy cursor on firmware 2.34
Date: Fri, 20 Mar 2009 22:46:37 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-170.2.35.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090320053509.GA3633@adopmeer.homeip.net>
In-Reply-To: <20090320053509.GA3633@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903202246.37383.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Thursday 19 March 2009 22:35:09 Arjan Opmeer wrote:
>
> +	if (etd->jumpy_cursor) {
> +		/* Discard packets that are likely to have bogus coordinates */
> +		if (fingers > old_fingers) {
> +			elantech_debug("elantech.c: discarding packet\n");
> +			goto discard_packet_v1;

Can we do this unconditionally for the v1 protocol and not have an
extra konb? Do you have access to boxes with unbroken V1 to test?

Thanks.

-- 
Dmitry

