Return-Path: <linux-kernel-owner+w=401wt.eu-S936031AbZDBLVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936031AbZDBLVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935649AbZDBLVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:21:15 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:24474 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759466AbZDBLVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:21:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=561WIZpUyzR375PV7Bjq9Crd/6PTn9RDkmKa8IeFJeiWlvy5vONwg929nHOJ8HRwg3A+chYftEyr5mlgtSqO3byOz/Fm3wplcSZG+aRUsKcFsKpvE7QgyXk+TshxkmQJabKvARKJhdHKamUYqVzxeLrepW9CnqxXsjvCNS0fPYs=  ;
X-YMail-OSG: 2L_Pv5sVM1ltgZ6eYczi1Uw4n7Ik6deFNDTs4W.Hh.hYkPmyt1iHYXN2PgecFSOPkj_p_japoHH2rpqCR_EgEV8PPg5IrIL7ZD3Li6VpkzJ95iZi5GMYvG9iualwa8.25FPOA5e2ROt8cSGEx.cU.1JypZrv.RNgZGdXL61TaeVwEFWUb_6U6v0WPCPZ4fmi1wUDlHx__gV0xHJ5TN_rCmjeirvDCc6E2PiLa8A.ShOP88VDl.fT4K3j0WPYsp5c9UIFSYPQjAf9AAcz8.mUU1yyd6DCHXpO9BmAilrXg2liw5V_1bHb
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: fs: move bdev code out of buffer.c
Date: Thu, 2 Apr 2009 22:21:07 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903280059.n2S0xvhK006987@hera.kernel.org> <20090330115524.e78dbe14.akpm@linux-foundation.org> <20090401111003.GZ28946@ZenIV.linux.org.uk>
In-Reply-To: <20090401111003.GZ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022221.07857.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 April 2009 22:10:03 Al Viro wrote:
> On Mon, Mar 30, 2009 at 11:55:24AM -0700, Andrew Morton wrote:
> > This patch moved the CONFIG_BLOCK=y declaration of freeze_bdev() out of
> > buffer_head.h and into fs.h.  But it left the CONFIG_BLOCK=n definition
> > of freeze_bdev() in buffer_head.h.
>
> Actually, there's more.
> 	a) fsync_bdev() export is left behind in buffer.c
> 	b) sync_blockdev/invalidate_bdev are like freeze_bdev/thaw_bdev -
> non-block stubs need to be moved.
>
> Fixed and pushed into for-next

Sorry about that, thanks. I always forget to test CONFIG_BLOCK=n :(


