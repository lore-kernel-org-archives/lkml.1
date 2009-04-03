Return-Path: <linux-kernel-owner+w=401wt.eu-S936834AbZDCUUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936834AbZDCUUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759523AbZDCUUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:20:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:10767 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbZDCUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:20:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G1IMSL4L/X+wbXYZ/voi3gmVA5Sw2CrL0Rn5i/Dcf+PDppl6Vr8pMgoIs9yIEgq1bb
         KM83LR/QR6p+9goTeLrrNDNBUawDml+IwW7g3aie4SOnxmh7GUQ5O5gXX/PLugACiUJY
         l1l4CBphneGAkgRPtodfRwYtLSCBT4RojGTIs=
MIME-Version: 1.0
In-Reply-To: <49D5B351.5040601@nokia.com>
References: <a95a62fe0904021632l14ddb299l7818f2f2d32c20ac@mail.gmail.com>
	 <49D5B351.5040601@nokia.com>
Date: Fri, 3 Apr 2009 13:20:37 -0700
Message-ID: <a95a62fe0904031320i2ce699ffm7aa94bce0a049bdd@mail.gmail.com>
Subject: Re: [PATCH] MTD: nandsim should delete its partitions on module 
	unload
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 11:57 PM, Adrian Hunter <adrian.hunter@nokia.com> wrote:
> Doesn't nand_release() already do that?

Yes.  The problem I was seeing (attempt to reregister mtd* sysfs
entries) was caused by something else.  I retract the patch.

Thanks.
