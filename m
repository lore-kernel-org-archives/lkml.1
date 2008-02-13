Return-Path: <linux-kernel-owner+w=401wt.eu-S1765450AbYBMBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765450AbYBMBGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYBMBGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:06:03 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:21066 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752537AbYBMBGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:06:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tLq6CuYxdovvYyF+zrRZcLxJsDUtdo/NAm/ldx8GBJYcSyaDXKKY7CkjDOOl26C/3wNDG14bh2WQZ2eypfRXVv3iGijLaloDvGGvSyEXEvEBUikhsh4A5+tHMkEVdF5goYVC+RQ7mwW5uxCcAkDJuJlz+6Nj2jGpbBUDysJ+Viw=  ;
X-YMail-OSG: nB0BsuEVM1lTz.YZOu8voFSXOjnvUYMS18CEh_KsIa51zTGrQRiBC9Cz5Zg7X8ZBpE73GsSSmA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel BUG at fs/mpage.c:489
Date: Wed, 13 Feb 2008 12:05:45 +1100
User-Agent: KMail/1.9.5
Cc: Bart Dopheide <dopheide@fmf.nl>, linux-kernel@vger.kernel.org
References: <20080212194546.GA2174@fmf.nl> <20080212215006.170ade88@core>
In-Reply-To: <20080212215006.170ade88@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131205.45493.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 08:50, Alan Cox wrote:
> > Feb 12 19:55:08 butterfly kernel: hde: dma timeout error: status=0xd0 {
> > Busy } Feb 12 19:55:08 butterfly kernel: ide: failed opcode was: unknown
>
> Your drive stopped responding.
>
> > Feb 12 19:55:08 butterfly kernel: hde: DMA disabled
> > Feb 12 19:55:08 butterfly kernel: PDC202XX: Primary channel reset.
> > Feb 12 19:55:08 butterfly kernel: PDC202XX: Secondary channel reset.
>
> We gave it a good kicking and it stayed offline
>
> > Feb 12 19:55:08 butterfly kernel: hde: set_drive_speed_status:
> > status=0xd0 { Busy } Feb 12 19:55:08 butterfly kernel: ide: failed opcode
> > was: unknown Feb 12 19:55:47 butterfly kernel: ide2: reset timed-out,
> > status=0xd0 Feb 12 19:55:47 butterfly kernel: hde: status timeout:
> > status=0xd0 { Busy }
>
> And we gave up.
>
> Almost certainly a hardware fail of some sort.

Right, but the kernel shouldn't go bug...

I don't have a copy of your exact source code... which condition in
__mpage_writepage went BUG?
