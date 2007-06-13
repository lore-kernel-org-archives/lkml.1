Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXFMFLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXFMFLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbXFMFLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:11:00 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:38827 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750772AbXFMFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:10:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=WrxIAumaHnhf9g+hqukk222V5T5TfQpX8lWYiJYrBwUTbmXhRkgIheyT4x/ZA/weTvmeDaPiHmulMsLescBcnaH+ydDUK1XFFmlxF6Sd8/4QpPHsR1ADW279RYIylJUjA6DMO2KVA8RAOlTtiNQOwW9CVDjQMKfGTgsdTDjpJ6w=;
X-YMail-OSG: OP6sAQEVM1lKlZrJR9umGJNlsR9eA9HUSp_eTyqtN3Lzcp4Y5tl3pbXWbSXipIPYMO5axA--
Date: Tue, 12 Jun 2007 22:10:58 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070612032553.GB19293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <830935.77535.qm@web50107.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Jones <davej@redhat.com> wrote:

> On Mon, Jun 11, 2007 at 04:49:47PM -0700, Greg Kroah-Hartman wrote:
>  > On Mon, Jun 11, 2007 at 04:30:11PM -0700, Doug Thompson wrote:
>  > > I am working with the k8 driver and its dealing with a race with the mcelog device as both
> access
>  > > the K8 NB. The K8 driver does use these regs and it currently has #ifndef s in it for both
> of
>  > > them.
>  > > 
>  > > I guess I could have submitted the patch when the K8 driver was submitted.
>  > 
>  > That would be preferable, thanks.
> 
> Even better (IMO), if they're not used by any other driver (which seems
> to be the case), keep the defines local to the driver.
> 
> 	Dave

There are 4 K8 Memory Controller registers, 2 of which are already in pci_ids.h (and are used by
others) and 2 more that I need. I define the 2 I need now in the file, but was worried when
someone else might add them to the pci_ids.h file.  Just figured that it would be better to keep
all 4 together.

So is the model of such placement to locate the #define near to the sole consumer of that item? 

And if used by others, to move it to the pci_ids.h file?

thanks

doug t

