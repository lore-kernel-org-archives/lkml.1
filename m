Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYA3REG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYA3REG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:04:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYA3RDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:03:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:64232 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYA3RDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vdgpMDlT3EF5VGVL0CTVFFSICVp4+F6/7wobqf70A7iPdM2nxY05fUckdXXHN3ZgVPrLXoUlGtHnSA9Hzh2I1ihTR0uXtZvui4DH7PM5x0k02eUCUXeeuRabDqat8lvi4/D+O3h74qdYQbjI5YmqSXGrxo0pVizD+y+PcNhxAFc=
Message-ID: <386072610801300903w13b3ea61j434b59a098a45a25@mail.gmail.com>
Date: Thu, 31 Jan 2008 01:03:52 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: [PATCH 1/1] [NOMMU]: Dont use kobjsize on the area belonging to a VMA
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47A075CD.6050800@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201688708-2152-1-git-send-email-bryan.wu@analog.com>
	 <47A075CD.6050800@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 9:04 PM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> Bryan Wu wrote:
> > From: Bernd Schmidt <bernd.schmidt@analog.com>
> >
> > Dont use kobjsize on the area belonging to a VMA, as it's allocated with
> > get_free_pages.
>
> As far as I remember, that's the case only in our tree with the patches
> in nommu.c.  So this patch probably shouldn't go upstream yet.
>

Oh, I picked up a wrong one. Could you please tell me which nommu.c
pathes does this one depends on?
I am sorting out all our nommu changes and try to send them out.

Thanks
-Bryan
