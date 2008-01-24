Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbYAXVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbYAXVJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYAXVJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:09:04 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:24373 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753607AbYAXVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:09:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oKCuQh0Fm7UhJl3zPBkz1/LqW7eyOILBOC4x1Amm+10O4vY0OMidv/PCR0ybN9p8ps9mMluLHEqR4vW1tQFkSw8GaxR+ZvQwWv0lA2Kabfrn/YZ/sCsqpHO8I8RDSKU5lJ8ptcpLJ0bPwoMYHgzGaEaLEibMmdU1H06cR7HOhCQ=  ;
X-YMail-OSG: .upZUNwVM1m47ApG6scp2V6EkS3lg9wZxKHtQMXaBLClM1fla2Z6o2uDiGN0jZG1QBHXMm5bdw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH -mm 1/2] Basic PWM driver for AVR32 and AT91
Date: Thu, 24 Jan 2008 12:53:13 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com> <1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801241253.13680.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008, Haavard Skinnemoen wrote:
> +config ATMEL_PWM
> +       tristate "Atmel AT32/AT91 PWM support"
> +       depends on (AVR32 || AT91) && EXPERIMENTAL

There's probably no need for EXPERIMENTAL except in the
limited sense of "young driver".  :)

There's a bug there ... it should have used ARCH_AT91 instead
of just AT91.  Or even ARCH_AT91SAM9263 || ARCH_AT91SAM9RL.

- Dave

