Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYKORj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYKORj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYKORjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:39:18 -0500
Received: from main.gmane.org ([80.91.229.2]:52872 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYKORjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:39:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Sat, 15 Nov 2008 18:39:04 +0100
Organization: Technische Universitaet Ilmenau, Germany
Message-ID: <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd54d5d.dip.t-dialin.net
User-Agent: slrn/0.9.9 (Linux)
Cancel-Lock: sha1:gD8BFZTNg1MMZ1nALRKg08EvEDs=
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?
...
> Host: scsi14 Channel: 00 Id: 00 Lun: 00
>    Vendor: _NEC     Model: DVD_RW ND-3520A  Rev: 1.04
>    Type:   CD-ROM                           ANSI  SCSI revision: 05

Well, if ata15 really is the CD-ROM, hal is likely to poll it :/


regards
   Mario
-- 
Evidently men are more intelligent than women. Every woman on earth
believes that men should be able to read minds. Every man knows this
is impossible. Ergo, we are more intelligent.

