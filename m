Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYHTP5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYHTP5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbYHTP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:57:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:51406 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbYHTP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=TS/8R4ydNOqqSzFahta2OC0/IKOAp5EO4J1qbaiqqzeGoFP6+vRG2FamFpa6+g4O0s
         jH77/fgMvF3fGxMcevs4jRywO0Qrn9F2fYLkwgT1GP32CYRUJqcUZMjFNYaU/bx4Yg0h
         DnZbHXAB7Aj6TuH3+oYu8H2e/dF08BYyeNSs8=
To: Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling through rfkill (v6)
Date: Wed, 20 Aug 2008 17:57:04 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       linux-wireless@vger.kernel.org
References: <48AB8902.3010406@overt.org>
In-Reply-To: <48AB8902.3010406@overt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201757.04501.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +	if (unlikely(state_changed)) {
> +		rfkill_force_state(dev->rfk_dev,
> +				   new_rfk_state ?
> +				   RFKILL_STATE_SOFT_BLOCKED :
> +				   RFKILL_STATE_HARD_BLOCKED);
> +		input_report_switch(poll_dev->input, SW_RFKILL_ALL, new_rfk_state);
> +	}
> +}

This looks very nice, but is the switch really toggling between
soft and hard blocked only? ;)

I mean shouldn't there be some unblock signal at some point?

Ivo
