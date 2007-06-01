Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbXFAXQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbXFAXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXFAXQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:16:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:36154 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXFAXQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mej4cHM6Z04lgNK6lyYRg1qyK8H2hLtTIBXnmei/57Wb+xPF1EsWlhlQnlzWpPTZuDbtAMxfJhgueZuT8ecyl6nOjO1rdpUweDdPbZXVsD3rIpw0msdU/nBp5FZxiWuacRyp28AA99lfXo+LnIboY31TWMGSjGnNR8ukDecmca0=
Message-ID: <6278d2220706011616k4c0950b0s7155f569935b6e60@mail.gmail.com>
Date: Sat, 2 Jun 2007 00:16:47 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Matthew Fredrickson" <creslin@digium.com>
Subject: Re: Device Driver Etiquette
Cc: "Lee Revell" <rlrevell@joe-job.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Jun, 19:40, "Lee Revell" <rlrevell@joe-job.com> wrote:
> On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
>
> > is it acceptable (although
> > not nice) to simply fix it this way, by disabling irqs while it loads
> > the firmware?
>
> I would say to just disable IRQs while loading firmware.  Almost every
> server I maintain has some vendor driver which generates a "many lost
> ticks!" message on load.  As long as it's only done at module load
> time it should be fine.

For anything ~10s or more, you'll probably also need to call the timer
update function to prevent soft lockup warning being generated.

> Of course the best solution is to just get the driver into mainline.
>
> Lee
-- 
Daniel J Blueman
