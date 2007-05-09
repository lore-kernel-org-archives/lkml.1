Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXEIMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXEIMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbXEIMYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:24:32 -0400
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:44700 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752989AbXEIMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:24:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=MRFZmvEt1uKyY+JPrKH8pUaIkDMbB9ZjYmZxrH1fBoiyw11tCdHGpik/qfX9JtLcAQytTpwjRouHWCJA+BDfS5Y0cXKUYUka/KK4RrISAtADWEsPs1kynoiHAx8S7tX/TU6qGrrhcI8bo+iPjrq/fO00fhDJg0f1bm9c9l1aATc=;
X-YMail-OSG: dzsR3vwVM1lk57BjWUW1UVwb83YB7xQrMXD.RMrXt.5FF4HC5GQfRI9dRjpc.5vByztmjoB6saY9eVOFz_vbUb3yRQDMNDqujvjzKqn65C1jpy4TGkRDFKlLTg--
Date: Wed, 9 May 2007 13:24:30 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel bug 8198)
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>
In-Reply-To: <46419711.8050003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <602729.80444.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> So, we can fix the problem Chris is seeing by breaking module unload (by
> allowing it to unload too early).  It doesn't sound too hot but module
> unloading race is much less likely than sysfs node deletion/open race.

Yikes! Just temporary breakage, I hope :-)!! The only modules I unload on a regular basis these
days are things like "microcode", which the init scripts take care of as part of the boot-up
process.

Thanks for all that hard work,
Cheers,
Chris



      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/
