Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYLDSwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYLDSwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYLDSwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:52:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:47446 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbYLDSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=V2kB4R0B2Qgo8q0hs8rasey/I78rH2/fL1bJnCGfdRzH89DbrtMiB1h+HY5gdp95LY
         XUerVyVhzjyxi+ihPrHav0Xyikv0wR2N5oTkC8vgYWdEdzvCxXWI+p8ceXOx/phF0Ixd
         BZrLbVhiR7xL6d15HFDCzNAgLg/Vf91mm418g=
Message-ID: <e9c3a7c20812041052l7fa7c148jf0a40318a2fe8cf4@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:52:28 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/4] dmaengine redux continued
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812040937010.5079@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
	 <Pine.LNX.4.64.0812040937010.5079@axis700.grange>
X-Google-Sender-Auth: 9262a8623c98c66b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 1:51 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> What about the last hunk from the patch at
>
> http://marc.info/?l=linux-arm-kernel&m=122607472721145&w=2
>
> ? Can we add this tx_free pointer? Would you like me to submit it as a
> separate patch? I'd like to be able to reuse tx-descriptors in clients, so
> I then have to explicitly release them in the dmaengine device
> (controller) driver.
>

I took a look but the description does not explain why the driver
needs an explicit release.  In what cases is the implied release, when
the descriptor is acked && done, insufficient?
