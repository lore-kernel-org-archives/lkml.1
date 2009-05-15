Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZEORMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZEORMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZEORMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:12:38 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:63040 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZEORMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=caIgPToJFKA0mcTrErRiSMIlmewhY5EqrtWiut9289V6DkNU9DVl/QT69s1yZf01QI
         pkxKvtFiyRQEfJZ0Y6GeWjBuuCh4+Nf60UmqtNO2am3NyT9ft9IN1GDHdlOKl4EAT5j8
         asJ3AoqbU2BVHi2lVcW9Tpk6NHs6Q93xhp1Sk=
MIME-Version: 1.0
In-Reply-To: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
Date: Fri, 15 May 2009 10:12:38 -0700
Message-ID: <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Mark Knecht <markknecht@gmail.com>
To: Satish Eerpini <eerpini@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:07 AM, Satish Eerpini <eerpini@gmail.com> wrote:
> Hello everyone,
>
> I am trying to figure out why the Linux desktop becomes overly
> unresponsive whenever there is a file copy going on, this happens to a
> large extent with GUI based file copying, and some lesser, but with
> command line copying too.
> does it have anything to do with the kernel ??,
> if it does help, then I am running Fedora 10 on a Hp nx 7400, Centrino
> Duo processor.
>
> Cheers
> Satish
> --

Quickly, is the system getting good hard drive performance overall?

hdparm -tT /dev/sda

or whatever device you are using. Maybe it's stuck in some sort of
programmed IO or something very old?

- Mark
