Return-Path: <linux-kernel-owner+w=401wt.eu-S937173AbXGMTBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937173AbXGMTBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761970AbXGMTBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:01:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:28801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbXGMTBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rumeuPsZMfxqRRRKp77ieF5+GiyH3hEFfoQYY0FkjtKuDSVL9RF2tba38kpamKv7x7y6tyr90gwJkUpL2YlMqhEyAtjuaX7iS+4p6sZYhS6GPkcRxMpW5X0peBIRlgN3LyQ3bEascvI050HE40+JhlkN4hwtT5xvw8sXUFdpCCs=
Message-ID: <d120d5000707131201x4ccfb41bk5fe610c299869514@mail.gmail.com>
Date: Fri, 13 Jul 2007 15:01:34 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RESEND patch 2.6.22-rc4 1/2] ads7846 sample settling
Cc: "Semih Hazar" <semih.hazar@indefia.com>,
       "Imre Deak" <imre.deak@solidboot.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707131129.10885.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707131129.10885.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HI David,

On 7/13/07, David Brownell <david-b@pacbell.net> wrote:
> From: Semih Hazar <semih.hazar@indefia.com>
>
> The ads7846 driver has support for filtering, but when the chip gets
> deselected between samples this causes noise. This patch adds support
> for an optional settling delay time, so that two consecutive samples
> will be taken with the specified delay time apart.  This ensures that
> the chip won't be deselected, so the noise won't appear.
>


Sorry for being unresponsive. I have both patches in my tree and I
will push them to Linus with my next batch for 2.6.23-pre-rc1.

-- 
Dmitry
