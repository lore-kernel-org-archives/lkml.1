Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYHEOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYHEOmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYHEOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:41:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:8374 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYHEOl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DCidNAsja3bx2mpz2veJfG2eI9ojla8txpcHoQ/3+PKZSQ8b28kgQxOj84QGGmFVZu
         DvxTV1Fw+CD7JIbLU7mYs6uRugleAwrS3bPmiyTYSOTMmp0oNptUAEE6ld56H+LobUMP
         Tq7t6lyNJuO9RglnK1wzaY9d2V0Nz0nEBTjps=
Message-ID: <58cb370e0808050741v7ff3f20awb3d91a84486f8547@mail.gmail.com>
Date: Tue, 5 Aug 2008 16:41:54 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715053356.GA18628@gollum.tnic>
	 <20080802183253.GA2239@gollum.tnic>
	 <200808022046.16990.bzolnier@gmail.com>
	 <20080803073756.GA8762@gollum.tnic>
	 <20080803125907.67676948@lxorguk.ukuu.org.uk>
	 <20080803143837.GA26672@gollum.tnic>
	 <20080803162214.394b13a1@lxorguk.ukuu.org.uk>
	 <20080803165135.GA31977@gollum.tnic> <4898630C.7090403@ru.mvista.com>
	 <9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 4:32 PM, Boris Petkov <petkovbb@googlemail.com> wrote:

[...]

> Will look into it later and redo the patch, thanks for reviewing. I
> still haven't heard from
> Bart, though, whether he's OK with the code duplication...?

Given Alan & Jeff concerns about moving it to <linux/ata.h>, just
copying the function to ide_generic seems like a best solution for now.
