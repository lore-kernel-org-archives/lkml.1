Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbZJFWyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbZJFWyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZJFWyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:54:05 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54109 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417AbZJFWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ju+IKiJ1NuLCWSPD3JVCMgDU9w9UzJBHi2Ybixm6fx7fbY5TqRuoZaXeYYMt9w2jsS
         pxoxQ3vuKzLq4HPMCH8iXIcVKp33UrnhiCo9pT8bnXZBrGEWlZdM8VRIz3x7pham2rBV
         3OMTzVoEh5ZIQemSMpAXc9KQtexKuCfve+FdY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] Revert "Revert "ide: try to use PIO Mode 0 during probe if possible""
Date: Wed, 7 Oct 2009 00:52:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: torvalds@linux-foundation.org, joao.ramos@inov.pt, david@fries.net,
       d.stussy@yahoo.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200910070027.45678.bzolnier@gmail.com> <20091006.154120.153174904.davem@davemloft.net>
In-Reply-To: <20091006.154120.153174904.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910070052.37964.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009 00:41:20 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Wed, 7 Oct 2009 00:27:45 +0200
> 
> > The root cause of reported system hangs was (now fixed) sis5513 bug
> > and not "ide: try to use PIO Mode 0 during probe if possible" change
> > (commit 6029336426a2b43e4bc6f4a84be8789a047d139e) so the revert was
> > incorrect (it simply replaced one regression with the other one).
> 
> What is this older "regression" fixed by the PIO-0 change?
> 
> You're not explaining it and neither does the commit message for the
> PIO-0 change.

It does:

| Subject: [PATCH] sis5513: fix PIO setup for ATAPI devices
| 
| Clear prefetch setting before potentially (re-)enabling it in
| config_drive_art_rwp() so the transition of the device type on
| the port from ATA to ATAPI (i.e. during warm-plug operation)
| is handled correctly.

and the empty port defaults to ATA-like behavior for the initial PIO setup.

> Please, fill us in :-)

Just connect the dots.. :)
