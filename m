Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZFBVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZFBVxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZFBVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 17:53:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFBVxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 17:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qQJrOW/H5AfN/JBUByOR95fch7GT7JCR+768qppaHFtMUyuzfg0DbbdfdYgD9Hx1vQ
         1aDiLcDiLLLv26UFqVrn26g/cERCVSgJarpaOv+L0ajPCJyQI5HcHb3hHi2wUVCa1X3W
         Gec5AU+lOzWKWAl+gRxjARPPbnYQx2mc/J38s=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Tue, 2 Jun 2009 23:53:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <200906021834.40009.IvDoorn@gmail.com> <1243961465.9894.3.camel@varda>
In-Reply-To: <1243961465.9894.3.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906022353.44284.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009, Alejandro Riveira Fernández wrote:
> El mar, 02-06-2009 a las 18:34 +0200, Ivo van Doorn escribió:
> > On Tuesday 02 June 2009, Alejandro Riveira Fernández wrote:
> 
> [...]
> 
> > > ICMP ECHO REQUEST
> > > 
> > > Any advance?
> > 
> > Well I checked the dumps from the bugreport, but like I expected
> > the only difference is that with the slow speed the correct value
> > is written, and the fast speed the wrong value is written.
> 
> So my chip works better with incorrect values written in its registers?

Apparently, probably because some other register is set to an incorrect value,
but I have no idea which one that would be.

> What about other chips out there do they prefer wrong values too ;)
> Maybe what we thought wrong values are not that wrong ?

They are wrong. That exact register initialization is pretty straightforward
in the original Ralink driver on which rt2x00 is based.

Ivo
