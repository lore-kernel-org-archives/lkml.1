Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYA3VBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYA3VBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYA3VBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:01:07 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:38889 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYA3VBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Iq5mLyjIEGBKv82SXr1MqGVlBytA13X62AmLOf76xqbM7w9nBISMovPZHzBP5eatlsfurYBPpTR/IEnyvuEOyRtXkdRrCwL3TAqCZ6OhbFDPp56SVkHbL1iMBIm0oabhoVMaP0Gr9j7Y8MELqLQBbe+N9SUmB5+uEMHfvFzjsDE=
Message-ID: <8bd0f97a0801301301k3951fi8dbe52ed859c9165@mail.gmail.com>
Date: Wed, 30 Jan 2008 16:01:03 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <bryan.wu@analog.com>
Subject: Re: [PATCH 11/12] [Blackfin] serial driver: ADSP-BF52x arch/mach support
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <1201685412-29095-12-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
	 <1201685412-29095-12-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 4:30 AM, Bryan Wu <bryan.wu@analog.com> wrote:
>  config SERIAL_BFIN_UART1
>         bool "Enable UART1"
> -       depends on SERIAL_BFIN && (BF534 || BF536 || BF537 || BF54x)
> +       depends on SERIAL_BFIN && (BF52x || BF53x || BF54x)
>         help
>           Enable UART1

erp, i just noticed this is slightly wrong ... BF53x is not OK as the
BF533 family does not have a UART1 ... i committed the fix to our repo
so you can re-post a fixed version of this for inclusion ;)
-mike
