Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXGXInb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXGXInb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXGXInW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:43:22 -0400
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:20950 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754666AbXGXInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:43:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=2+qjmAQTE/WKRzi42NGlc1TaHLxh9RbffQ3DjDYefj0NoLgr+NYizs2L3cueTjOyp9QxvfPqwr5CQMI1GiSWMFL/epoqoswH+vvY9Oh0AveEhZEz9LymM3dSTPIGHSiSki7I1nrBmg9oBKC8Xz/Xru510uNJa1AWgEfWLUR2jck=  ;
X-YMail-OSG: G9kCYUEVM1kBvuT.cchR7Sv6TZDdbXql88Rpv80.v9UTHHVjsDMHht7P75m9Xm.XfG2MKVMb7Q--
Date: Tue, 24 Jul 2007 10:42:39 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb/atm: fix Kconfig garbage
Message-ID: <20070724084239.GA21356@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070723065604.GA8525@gollum.tnic> <200707241028.56325.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707241028.56325.duncan.sands@math.u-psud.fr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 10:28:55AM +0200, Duncan Sands wrote:
> Hi,
> 
> > When entered, the menu point "USB DSL modem support" in menuconfig, path [Device Drivers->USB
> > Support] shows no entries but "^@" instead. The following fixes it.
> 
> is the problem that there are no entries, or that "^@" is displayed?  If there are no
> entries then presumably you didn't turn on ATM support.

I thought simply that when "^@" is displayed then something is wrong with the
menu in Kconfig but the reason was that ATM was not enabled, that's all.

-- 
Regards/Gruﬂ,
    Boris.
