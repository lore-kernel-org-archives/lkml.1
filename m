Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZAJN6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZAJN6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZAJN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:58:05 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41964 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbZAJN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:58:03 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bisected] Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Date: Sat, 10 Jan 2009 14:57:58 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
References: <200901091334.55823.borntraeger@de.ibm.com> <20090110132412.GB14049@elte.hu> <20090110133617.GA22304@elte.hu>
In-Reply-To: <20090110133617.GA22304@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101457.58602.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 10 Januar 2009 schrieb Ingo Molnar:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > build its random kernel and reboot into it (800 MHz P3), so i started a 
> > full automated bisection instead driven from a faster box.
> 
> and the winner is:
> 
> | 871af1210f13966ab911ed2166e4ab2ce775b99d is first bad commit
> | commit 871af1210f13966ab911ed2166e4ab2ce775b99d
> | Author: Alan Cox <alan@redhat.com>
> | Date:   Mon Jan 5 14:16:39 2009 +0000
> |
> |     libata: Add 32bit PIO support

Yes, thats what I send Alan yesterday. We currently try to understand why it 
fails.

