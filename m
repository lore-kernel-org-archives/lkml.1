Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbZKYRrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbZKYRrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbZKYRrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:47:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:57215 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbZKYRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=KTosZVxV5Di0WOEFudtyQA3ISp2DJSYJFcAPmg8CqSsNpmeoYvsqCaQax4uysvOSTP
         tBUrjhL8HzK/efSs9b8GpiXS29TRNVT2ZH5JciIrAkoivss0ALUKvvondq1EBl/dpRP3
         Qu0vL+wxVYuMIXy6nEK5zMJrVacm6B77Nf7ok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 45/86] pata_legacy: do not probe extra ports automatically if PCI is not present
Date: Wed, 25 Nov 2009 18:45:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170740.5446.67217.sendpatchset@localhost> <20091125173215.539b5630@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125173215.539b5630@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911251845.52700.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 06:32:15 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:07:40 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_legacy: do not probe extra ports automatically if PCI is not present
> > 
> > It can be problematic if there are other ISA/VLB devices using
> > those ports.
> 
> NAK. You made a rather peculiar set of changes in the IDE layer but the

Please give commit numbers and describe such 'peculiar set of changes in
the IDE layer' in more details or skip such baseless, unjust and pointless
comments from your mails.

> PCI handling in pata_legacy includes knowledge of the various half-pci
> devices and on a non PCI system 0x1E8/0x168 are reserved for extra IDE.
> 
> We've had no complaints at all, ever about this.

OTOH We had. :)

--
Bartlomiej Zolnierkiewicz
