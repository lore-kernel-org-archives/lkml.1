Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZICCMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZICCMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZICCMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:12:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:6671 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZICCMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=XGGRLHQmyo9AH4uNNgZzMRmhCyUDEjdxXzp510Z4+VMSgZw1zNxtfBw3yPurE7tQyR
         wQc7WiNEof/imPpLafDvR/csGMX55WAxCuk6v06uAEDWvGtf7VAmDvY1OKZuGMas1kKR
         mpHVjajwjny7OsVBBJYe0TCKgTywH+rBsh2mQ=
Date: Wed, 2 Sep 2009 23:12:14 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-ID: <20090902231214.495d4002@pedra.chehab.org>
In-Reply-To: <20090902121713.f709b1ce.sfr@canb.auug.org.au>
References: <20090902121713.f709b1ce.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 2 Sep 2009 12:17:13 +1000
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> drivers/media/video/gspca/Kconfig between commit
> b6b85048c059e3f085095e48e12ed3f7a92c88d4 ("V4L/DVB (12502): gspca -
> sn9c20x: Fix gscpa sn9c20x build errors") from Linus' tree and commit
> 7b5ab5558fbce09584d8795bc91eb64d8c685782 ("V4L/DVB (12452):
> gspca/Kconfig: Fix bad identation for USB_GSPCA_SN9C20X_EVDEV") from the
> v4l-dvb tree.
> 
> I fixed it up (see below) and will carry the fix for a while.

Thanks.

I've rebased it to fix this merge conflict between my devel tree and upstream.
You probably can drop it on your next merge.



Atenciosamente,
Prof. Mauro Carvalho Chehab, MSc, CISSP
maurochehab@gmail.com
