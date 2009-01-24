Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZAXOtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZAXOtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZAXOtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:49:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:20689 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZAXOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bj6saFU2XvQTVoOFSWG3mOdhHM3Rg84Fec/L4IF0Jm2tz0EFlSY10SEkSghfPXPTwp
         LwhOKFAb2ZfhBCfR/NgXMRM+oOFIooX4vy+LQm1Gnrjq6JCfCdN2R0QAATSfJsmd3uKb
         f1csUC2EPbeDGEUSFMElS1bmY4XYLvBk2z5Sg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0901241425310.13803@anakin>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
Date: Sat, 24 Jan 2009 16:49:45 +0200
Message-ID: <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/24 Geert Uytterhoeven <geert@linux-m68k.org>:
>
> FYI, I've just seen the other patch you posted before.
> I'm also wondering what's really going wrong, as I haven't ever noticed this
> problem during the last 10 years.
>
Looks like the problem is connected to using HW-cursor, and not so
many framebuffer drivers do that, I've seen this only on atyfb.

Risto
