Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYAJXFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYAJXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYAJXFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:05:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:36247 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYAJXFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GPFXeZzoqpoC1xeqCCi3qJPOZOcR79uvqh2QHbyAE85Rb0//MIViHE/VXyslQPCx/Eis9MHw73QtWSMUSVeCE/Oaa1Uaau+BjrxW0jA1COq3tniDYOCT7sgg3QLmAk6BOLbYlQOOnNvF7qsEyRzNuHACKBE/XJE4ZKlPKbI4bZ8=
Message-ID: <9a8748490801101505y7b163f9ev8fdc3102281003fb@mail.gmail.com>
Date: Fri, 11 Jan 2008 00:05:41 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Re: Kernel Oops?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <6d291e080801081924p749ae6d2x1618fb7c234c8c22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080801071515wf7ebbccu744e3e3eca6bb0a9@mail.gmail.com>
	 <20080107233008.0c1b928c@lxorguk.ukuu.org.uk>
	 <6d291e080801081825g951ef59j1eb37d6b43f11ec5@mail.gmail.com>
	 <20080109030215.4e3f0992@lxorguk.ukuu.org.uk>
	 <6d291e080801081924p749ae6d2x1618fb7c234c8c22@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2008, Stoyan Gaydarov <stoyboyker@gmail.com> wrote:
> On Jan 8, 2008 9:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > Except this time when rebooting the machine i got a kernel oops
> > > message and it didn't boot completely. I could not copy it but I did
> > > take a picture and now I have re-written the screen here(sorry about
> >
> > That is interesting - that sort of error usually points at memory
> > corruption and early on tends to point at hardware (but not always). What
> > hard is in this system  and does it have over 4GB of RAM ?
> >
> >
>
> There are 2GB of RAM and the motherboard is DFI and it has a duel core
> intel cpu. If you need to specifics I could look them up.

cat /proc/cpuinfo
cat /proc/scsi/scsi
cat /proc/interrupts
lspci -vvx

should give you most of the details :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
