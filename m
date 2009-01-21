Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbZAUSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbZAUSNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZAUSNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:13:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZAUSNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:13:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=QT5R9LnH9QkjdKMGUT0HAg1S22pePjMmq1/RDYSTbcFKpgsDII4A4BXAggMC/RzOt
	z1SRNvDkqa28JrIqMrg7Q==
MIME-Version: 1.0
In-Reply-To: <20090121153229.4a11cb8e@lxorguk.ukuu.org.uk>
References: <ee007d8e0901201524s3be5e8e2m7d1d4026c078a87@mail.gmail.com>
	 <20090121153229.4a11cb8e@lxorguk.ukuu.org.uk>
Date: Wed, 21 Jan 2009 10:13:02 -0800
Message-ID: <ee007d8e0901211013i7a5b3bc9w23c9c94e88296c0@mail.gmail.com>
Subject: Re: tty_tiocmset() masks out TIOCM_RI and TIOCM_CD, which breaks 
	rfcomm
From: Adam Bliss <abliss@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@flint.arm.linux.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: abliss
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan.  Thanks for the reply.

On Wed, Jan 21, 2009 at 07:32, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> I would have expected the driver to be remapping RI/CD just as it does
> for the DTR<->DSR RTS<->CTS cable switch around.
>
> It's certainly possible to fix it, but that would need a double check on
> the existing drivers and that passing new suprise bits won't do any harm.
> The real question is what should the right behaviour be - and to me that
> seems to be to logically flip all the lines not just DTR/DSR RTS/CTS

What would you expect the driver to map RI and CD to?  I don't think
there are DTE->DCE signals that correspond to RI and CD.  Possibly
OUT1 and OUT2 could be used, since I don't think these are used
anywhere else in rfcomm, but this might be unintuitive.  I'll let
Marcel address that idea.

--Adam
