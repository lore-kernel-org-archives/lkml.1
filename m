Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0BXKTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:19:42 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:46244 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0BXKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:19:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FX1ymLSGYeToeO6tyNUUgMFmvfVIF3KDl0XV/hrbmImhbykDKjgHKr8hcMA/bTX//t
         imzktSeQMKPaLl6VPiwRNTwuisbS46JwPgDwPKnA76x2/C1cRFEjcdJxKsZTB5toQBfC
         bxCJY09AsEYkMHgs0eZf0JYgDnqR5rJZMWqQ4=
Date: Wed, 24 Feb 2010 02:19:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] winbond-cir: fix suspend/resume
Message-ID: <20100224101936.GA8036@core.coreip.homeip.net>
References: <20100210220025.GA10609@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100210220025.GA10609@hardeman.nu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 11:00:25PM +0100, David Härdeman wrote:
> I finally got the time to fix suspend/resume with the winbond-cir
> driver on my mainboard. The main problem turned out to be that the
> ACPI _DIS method would completely power off the SP3 module which
> meant that the output lines (including IRQ lines) would be left
> in an undefined state which could cause spurious interrupts and
> that the hardware has to be reinitialized from scratch during
> resume.
> 
> This fixes:
> http://bugzilla.kernel.org/show_bug.cgi?id=15257
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

Applied, thank you David. Let's see if I manage to quieeze it in .33.

-- 
Dmitry
