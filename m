Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYBLAOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYBLAOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbYBLANN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:13:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:11366 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbYBLANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:13:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Rx0AJhwsoR8a7giPw5rwDa0n0Jpq6AX8/g9pnG6xZ9wHSCZoTuCzm8Hlfluz/BipcfX/elJ8QKSiCEVHfLlMFFHGDzDLkcmB91do7L1bat0CzfDYgTJEusli0d2gqYUy+I8pWuS1O7vy++QOgf0MUmqCUZc77eXz6QlpAgcJ20E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] ide: Add missing base addresses for falconide and macide
Date: Tue, 12 Feb 2008 01:15:37 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Michael Schmitz <schmitz@debian.org>, linux-ide@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0802112232060.7963@anakin>
In-Reply-To: <Pine.LNX.4.64.0802112232060.7963@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120115.37876.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008, Geert Uytterhoeven wrote:
> commit 29dd59755a849cc6475faa6a75f3b804e23a6fc2 ("ide: remove ide_setup_ports")
> forgot to take into account the base addresses for the CONTROL registers for
> falconide and macide, as pointed out by Michael Schmitz.
> 
> Falconide was tested on Aranym.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Michael Schmitz <schmitz@debian.org>

Thanks!  Applied.

[ this patch was a missing link to (hopefully) bring the number of open
  2.6.25 IDE regressions down to _zero_ ]
