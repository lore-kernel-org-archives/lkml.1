Return-Path: <linux-kernel-owner+w=401wt.eu-S935194AbZJORQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194AbZJORQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935171AbZJORQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:16:38 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:42650 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329AbZJORQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=duujpvhEhpZi9rm5tKKLsBbr4yQYi+RMWwtL8oR4r4VV5Mjz1e2dO8vmxUpPuTVX53
         jP4B1gUUEthHUA6wdPZFkeCLbnmKnbd3EKAQ1LiZkpG6gnrE9edV5hmsatVkO4+H+ciI
         omG2gzJVn6rTx4wbQ/X4aPUjsxiqFnDcK0rnY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0910141734310.5568@p34.internal.lan>
References: <alpine.DEB.2.00.0910131723510.5034@p34.internal.lan> 
	<alpine.DEB.2.00.0910141123280.23631@p34.internal.lan> <alpine.DEB.2.00.0910141441410.5322@p34.internal.lan> 
	<alpine.DEB.2.00.0910141734310.5568@p34.internal.lan>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 15 Oct 2009 13:15:40 -0400
Message-ID: <3e8340490910151015se2df7a2sa505820749f480d2@mail.gmail.com>
Subject: Re: 2.6.31.3: Machine hangs at reboot (Intel DP55KG motherboard)
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 5:34 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> I tried the reboot=b kernel parameter-- to no avail either.
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/115011
>
> http://lkml.org/lkml/2007/6/5/59
>
> This workaround did not work.

Try each of the following in the reboot= parameter: acpi, smp (32-bit
only), triple, efi, pci, warm, cold, force
If one of them works, report it, along with the output from dmidecode
and lspci -nn, so a workaround entry can be added.
