Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYASTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYASTOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYASTOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:14:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:33422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYASTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OMlt0fau9sWcdsCEQ10o8xS66PF/ft57hRx07o6E9iIOA+u6Gc6/oATAmgYFqPJ/20oqAlyLluJ+d1MuZLRa+DhLwcJqhlD1t1wrTfrWCx68YXGqCccyfXdCvxtREaODP9u1NXQ8/hYnH2H8V9qM1kZKg4GSEfHBfP00OKkoNdU=
Message-ID: <6101e8c40801191114v4492d8fer4da13477ef2d5626@mail.gmail.com>
Date: Sat, 19 Jan 2008 20:14:01 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Lars Callenbach" <lars.callenbach@gmx.de>
Subject: Re: linux device ordering at boot time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080119185520.208350@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080119185520.208350@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know, what the proble, but the fstab workaround  functioniert:
form:
/dev/sda3       /               xfs     defaults        0       1
to:
UUID=7c167a53-30ff-4d47-a206-ce8caf2397ba       /               xfs
 defaults        0       1

in this fix switched form device name to UUID based fstab.

the uuid-s queried with /lib/udev/vol_id program

/*sorry for bad english*/

On 1/19/08, Lars Callenbach <lars.callenbach@gmx.de> wrote:
> I have a question concerning the ordering of devices during the boot process
> and I hope that the kernel mailing list is the right place for this
> question.
> In my computer are two raid controllers with one raid array connected to
> each of them (/dev/sda, /dev/sdb). In the debian 2.6.18 boot process the
> ordering is root @ /dev/sda and data are on /dev/sdb. This behaviour has
> changed in the plain 2.6.23.1 (and 2.6.23.8) kernel. The /dev/sd(a|b)
> devices have switched so that root @ /dev/sdb. So my standard fstab does not
> work.
> What determines the device ordering during the boot process? What is a
> workaround for this problem?
>
> Thank you very much for some hints,
>    Lars
>
> --
> Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten
> Browser-Versionen downloaden: http://www.gmx.net/de/go/browser
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
