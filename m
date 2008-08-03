Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYHCNku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYHCNku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYHCNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:40:42 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:13853 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbYHCNkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gltdJKZ5o+ZR35G3M+tzrOH1dwOMmPay+SOJm2Cp7LYxGYMfwz6Qq5vFhgcH3IQJHl
         az80/G+z+JTOh4kFNFWSDFxWzgwqO1UZGruz4bqCiNktduHUUrbGjGp9qNC+KWoPGSSb
         1OQt8nTa+1IXgwbc0W3auvYQDT5z3WiG7kQbU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Date: Sun, 3 Aug 2008 15:37:40 +0200
User-Agent: KMail/1.9.9
Cc: petkovbb@gmail.com, petkovbb@googlemail.com, alan@redhat.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
References: <20080715053356.GA18628@gollum.tnic> <20080803073756.GA8762@gollum.tnic> <20080803125907.67676948@lxorguk.ukuu.org.uk>
In-Reply-To: <20080803125907.67676948@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808031537.41224.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008, Alan Cox wrote:
> On Sun, 3 Aug 2008 09:37:56 +0200
> Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > Ok, here's a definitely better solution:
> 
> Please don't stuff large important pieces of code in header files where
> they will be overlooked
> 
> NAK this.
> 
> I'm happy to have a shared library directory for ATA stuff, containing
> useful C code, but hiding stuff in headers like that is just plain wrong.

The code in question is 65 LOC total (43 LOC without counting comments)
so having a shared library just for it sounds like an overkill and we may
just copy that one function from pata_legacy to ide_generic instead.

Jeff, what is your stance here?
