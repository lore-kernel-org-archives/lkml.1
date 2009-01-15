Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZAOBEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZAOBEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZAOBEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:04:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:34789 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbZAOBEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c5vLiU0Q4ZhdVDCctxthWAujnCS4dkUlPs0tb/PIn4VZKSLkpShwcgzB3kJPcTvh1u
         Y8mkdBhKkuCA09q/tZU5VKu3oZNENs5j5Cu5htHgM5ULkDCoWzUUU9XERMbHO4TKy4nc
         gVKdRFdnUnh3ueSMgySQm7eCzxh212ymaPveI=
MIME-Version: 1.0
In-Reply-To: <496E2BE5.1050803@cam.ac.uk>
References: <496E2BE5.1050803@cam.ac.uk>
Date: Thu, 15 Jan 2009 09:04:22 +0800
Message-ID: <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support 
	within mfd driver.
From: Eric Miao <eric.y.miao@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       Mike Rapoport <mike@compulab.co.il>,
       Samuel Ortiz <sameo@openedhand.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 2:16 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>
> From: Jonathan Cameron <jic23@cam.ac.uk>
>
> Add support for changing the mode of the da9030 usb charge pump
>

Well, if it is totally USB charger related, I'd suggest to move this into
the dedicated driver. This mfd/da903x.c serves as a common code
base for all sub-peripherals.
