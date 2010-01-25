Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837Ab0AYCZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0AYCZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 21:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088Ab0AYCZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 21:25:10 -0500
Received: from mail-iw0-f183.google.com ([209.85.223.183]:36593 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0AYCZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 21:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RX9ICVvXXH71yzw7iWvsxkfKJ/hH0hTzTpPX9xKzJd+mieZakYmMKfRvChKvZpTVCa
         VFaWt9VTHHIJd3hskFFwUFarQhDjVDJ+0teycKTpqjz7XuG1ojX7nMf5sMDQGaWms6cM
         OwaE+lt8cWY1OjFf50EIODcKmyk/Y85XMCbNI=
MIME-Version: 1.0
In-Reply-To: <q60Z28d_9yH.A.aX.kZMXLB@chimera>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
	 <q60Z28d_9yH.A.aX.kZMXLB@chimera>
Date: Sun, 24 Jan 2010 20:25:06 -0600
Message-ID: <51f3faa71001241825yec6e37br8032b7a3730ce840@mail.gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata 
	controller
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 24, 2010 at 4:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14922
> Subject         : 2.6.32 seemed to have broken nVidia MCP7A sata controller
> Submitter       : Mike Cui <cuicui@gmail.com>
> Date            : 2009-12-19 6:13 (37 days old)
> References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> Handled-By      : Jeff Garzik <jeff@garzik.org>
>                  Robert Hancock <hancockrwd@gmail.com>

It's a confirmed regression. Waiting on some lspci -nn output from the
reporter. However, for now, disabling auto-activate optimization on
all NVIDIA AHCIs may be the easiest option.
