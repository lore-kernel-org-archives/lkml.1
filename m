Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZKFSRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZKFSRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbZKFSRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:17:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:42980 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315AbZKFSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tzBRJqib4UWpSXWjBNmEj753poONgLM+Iq9KtmkCwh8fy1YbzM3DLs4jq66b07/Nv+
         Nr7W2u25LWUzsYptncOul2ZwidpYfE6UixJTx7G4hHSasj7qsYSda0aATthgHtinTlBC
         8IDRZ7OBKhAXo0z9CkEERg6Hc3e+nFhgI3tUw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 13/41] rt2800usb: add rt2800_regbusy_read() wrapper
Date: Fri, 6 Nov 2009 17:23:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173334.28463.13649.sendpatchset@localhost.localdomain> <200911051949.28617.IvDoorn@gmail.com>
In-Reply-To: <200911051949.28617.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061723.10099.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009 19:49:28 Ivo van Doorn wrote:
> On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] rt2800usb: add rt2800_regbusy_read() wrapper
> > 
> > Part of preparations for later code unification.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> The macros are the same for rt2800pci and rt2800usb.
> So it might be better to move the entire define set into rt2800lib.h

Indeed, it wasn't possible before patches #13-14 but it is now.

Would you like to send an incremental (on top the series) fix for it?

Thanks.
-- 
Bartlomiej Zolnierkiewicz
