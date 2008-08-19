Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbYHSU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbYHSU1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYHSU1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:27:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:39017 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYHSU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=nnhc7l9HBjyuiqkYdYsuKWvVo4o6m17kSVaSkRRs6tbMD+NO4pjyaXPpLrjp5tHyNz
         qGkKWKwM1zfZY9cUPshDWu3MDv+NcaCzQcwaXJZAMjC3yFjvu/u4dTL4uCstftUIUI0O
         ryVo9xpfgH2g9bubxArmAUH+sbfqVAay48hmw=
To: "Alex Riesen" <raa.lkml@gmail.com>
Subject: Re: rt2500pci: false alarm (was rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed)
Date: Tue, 19 Aug 2008 22:25:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com>
In-Reply-To: <81b0412b0808191208y6bef9187nc57fa74c08a92d54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192225.45030.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008, Alex Riesen wrote:
> 2008/8/19 Alex Riesen <raa.lkml@gmail.com>:
> > 2008/8/19 Ivo van Doorn <ivdoorn@gmail.com>:
> >>> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
> >>> produces a lot of this messages in log (slowdown quite noticable):
> >>>
> >>>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
> >
> > It surely did, but I honestly don't remember what with. I'll try to bisect.
> >
> 
> Ok, it _is_ the hardware. Precisely: it is a dusty box in a dark humid corner.
> I reseated the card and suddenly everything started working.
> 
> I'm really sorry. The error description was actually a very good
> hint at the problem.

Well good to hear that at least the card itself isn't broken and it was
only a matter of moving the card a bit to make it work. :)

Ivo
