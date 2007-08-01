Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbXHAIgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbXHAIgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbXHAIgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:36:03 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:24862 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbXHAIgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kC4SmB0RXJ8Q1OAvYDVS+1MsqB5sgwMX3kXuW+t852Kt3LHXket6KOAyXbKKTcf991U7Oz3d18jaFW4bcE/JazugBk/B9YL6pox9nM6JwSvZvH9S51KWZbgxbigY2FYt3g7CEtM6nUajSlEzp03bitKypimMXsagFtvZDDysZM0=
Message-ID: <a8e1da0708010135we34a17dl604d9f8c3eb630f8@mail.gmail.com>
Date: Wed, 1 Aug 2007 08:35:51 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: dwmw2@infradead.org
Subject: MTD: pnc2000 iomem oops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The pnc2000 probe function  cause oops. Possible reason is its iomem
region not being remaped.

I searched lkml history, the oops was reported at 2006-06-14, but still there.
http://lkml.org/lkml/2006/6/14/59

If the ioremap/iounmap can be added to it, is it the right fix?

Regards
dave
