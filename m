Return-Path: <linux-kernel-owner+w=401wt.eu-S1759478AbXFDRq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbXFDRq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759102AbXFDRqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:46:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:27420 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbXFDRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i9rKmmqPEUomweXTrzZLsj/jBfEAOGVDQdXSbibpFS4pphx/v91vVMEfUDIg6Z25TrXY5HrQxdTRGYR5C42Mes/fXExqreqB7MI5VboziMmc3uyVu/OEQ51PyY9sVAigMcqIgicjDSOdhWwE05PfMzfLt9e8valTy7N99SZs0Vo=
Message-ID: <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com>
Date: Mon, 4 Jun 2007 13:46:45 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Cc: "Pavel Machek" <pavel@ucw.cz>, "Andi Kleen" <ak@suse.de>,
       "Jiri Kosina" <jikos@jikos.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070604163406.GA1120@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070604112426.GA2707@elf.ucw.cz>
	 <20070604130903.GC1971@elf.ucw.cz>
	 <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
	 <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz>
	 <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com>
	 <20070604163406.GA1120@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Mon, 04 Jun 2007, Dmitry Torokhov wrote:
> > >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> > >often. Launch the line above and try to do some typing...
> >
> > This used to work fine on my box last time I tried it (the switch
> > itself is offloaded to a keventd and shoud not get in the way) but
> > then they push all kind of ACPI/SMM crap together with KBC so who
> > knows... I should try it again when I get home.
>
> Err... in laptops, almost *always* the KDC is emulated by the embedded
> controller, so I bet you're right on the money, there.  It is not "a buggy
> KDC", it is a buggy EC firmware and/or buggy SMBIOS which is a lot more
> common.
>
> And DoS'ing the EC is very high on the Don't Do That list on a laptop.  If
> the X60 is only losing keypresses and producing no bigger fireworks, that's
> outstanding behavior (as far as I trust ThinkPad firmware, anyway).
>
> So please throttle anything that might access the KDC way too much (as
> compared to normal keyboard operation by an user).

What would be reasonable throttling? Once every 100 ms?

-- 
Dmitry
