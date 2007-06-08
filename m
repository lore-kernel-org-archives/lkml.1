Return-Path: <linux-kernel-owner+w=401wt.eu-S1031274AbXFHSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031274AbXFHSaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970688AbXFHS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:29:52 -0400
Received: from relais.videotron.ca ([24.201.245.36]:51445 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970684AbXFHS3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:29:50 -0400
Date: Fri, 08 Jun 2007 14:29:53 -0400
From: Mike Schmidt <mike@intello.com>
Subject: Re: 2.6 kernel: Cannot make multiple dummy network interfaces
In-reply-to: <20070608175058.GG10008@csclub.uwaterloo.ca>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org
Message-id: <4669A021.4070004@intello.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_whubfqKSsucI4gHWmAJmtw)"
X-Greylist: Sender succeeded SMTP AUTH authentication,
 not delayed by milter-greylist-3.0 (deepspace.sepia.com [205.236.40.42]); Fri,
 08 Jun 2007 14:25:08 -0400 (EDT)
References: <46699318.3060209@intello.com>
 <20070608175058.GG10008@csclub.uwaterloo.ca>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_whubfqKSsucI4gHWmAJmtw)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

Oh, yes! Thank you. The one thing I didn't check - since dummy had no 
parameters in 2.4 kernels, it didn't occur to me to do a modinfo. I just 
did a modprobe dummy0 numdummies=99 and there we are - 99 devices. Thank 
you. I will pass this info on. I searched high and lo through user 
groups and mailing lists, but dummy is such a common word that it is 
difficult to narrow down the search.
Thank you again.

Mike

Lennart Sorensen wrote:
> # modinfo dummy
> filename:       /lib/modules/2.6.18-4-gx1/kernel/drivers/net/dummy.ko
> license:        GPL
> vermagic:       2.6.18-4-gx1 preempt mod_unload GEODEGX1 gcc-3.3
> depends:
> parm:           numdummies:Number of dummy pseudo devices (int)
>
> Perhaps you want to pass that numdummies aregument with some value.  The
> default may be pretty low.
>
> --
> Len Sorensen
>   

--Boundary_(ID_whubfqKSsucI4gHWmAJmtw)
Content-type: text/x-vcard; charset=utf-8; name=mike.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=mike.vcf

begin:vcard
fn:Mike Schmidt
n:Schmidt;Mike
org:Intello Technologies Inc. 
adr;quoted-printable;quoted-printable:;;580 1=C3=A8re Rue;Saint-Jean-sur-Richelieu;Qu=C3=A9;J2X 3B4;Canada
email;internet:mike@intello.com
title:Vice-President
tel;work:450-358-2266 x223
tel;cell:514-835-9497
x-mozilla-html:FALSE
url:http://www.intello.com
version:2.1
end:vcard


--Boundary_(ID_whubfqKSsucI4gHWmAJmtw)--
