Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbYDOJyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbYDOJyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760475AbYDOJyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:54:39 -0400
Received: from web26102.mail.ukl.yahoo.com ([217.146.182.143]:45838 "HELO
	web26102.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758790AbYDOJyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:54:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ahrrX72ZsxRf+BH4vDxtSIQ8ez010EHJH1cXZHf7Q4y2kD3MR1msQrW/Vc5UBEQihayGmNW/OtzqsBUNonoq7osLTvv/qquGA501X/JEp4eHqSgtowzB+x0fF56kTSA8Pc0iP8PKC+0zqb0b+80hgYm4BGLaVzOskDo7JDaT3Ds=;
X-YMail-OSG: uNZDgMUVM1nL4Ig7fbKQsuR86aPLZdKYcMXCWC9H7HVkVMw5uR81TKfblqIExB1Vi_JQu9iJ1n7OfKFi1pysuxWZuP_RZYE-
Date: Tue, 15 Apr 2008 11:54:36 +0200 (CEST)
From: linuxcbon <linuxcbon@yahoo.fr>
Subject: RE : Re: RE : Re: Question about Creative Webcam Pro PD1030 ? Bug ?
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Video <video4linux-list@redhat.com>
In-Reply-To: <20080414172208.3b20e53d@areia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <969007.77776.qm@web26102.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Mauro Carvalho Chehab <mchehab@infradead.org> a écrit :

> > I forgot to cc the linux mailing list, so here it is again.
> 
> The better is to copy V4L mailing list.
> 
> > hi Mauro,
> > 
> > thanks for your answer !
> > 
> > I already contacted the authors (Mark,Wallac,Olawlor), but no feedback
> > yet.
> > 
> > I got no oops message from kernel.
> 
> So, this doesn't seem to be a driver issue. I suspect that your
> userspace app
> is trying to configure an unsupported configuration. This driver still
> implements the legacy V4L1 API. Maybe converting it to V4L2 would solve
> your
> issues. Another option is to check if gspca driver works with this
> device.
> 
> Cheers,
> Mauro

Hi,

lsmod gives :
ov511                  77072  0 
compat_ioctl32          1408  1 ov511
videodev               27904  1 ov511
v4l2_common            16896  1 videodev
v4l1_compat            14596  1 videodev

This device works with OV511+ 
(see http://alpha.dyndns.org/ov511/cameras.html).
Difference between OV511 and OV511+ ?

cheers, linuxcbon




      _____________________________________________________________________________ 
Envoyez avec Yahoo! Mail. Une boite mail plus intelligente http://mail.yahoo.fr
