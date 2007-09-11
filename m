Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbXIKT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbXIKT4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbXIKT4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:56:38 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:30638 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934135AbXIKT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=H8xZV3vQceTMMjBa1HQ1zgPFpi1+idNKtXdOL7tZ0UdV7kawWpJ+8paCWV+k7rafaCEoGyYYtnROe9IEhvlPLhJmpcM/jq4vdrojwRM1+Hjr7dJVt+qlBvx1ufKJEjir75YCcgxIwsm+Tu+FGKYsdxnvhs3tFd+tn77FVcDsVbI=
Message-ID: <31e679430709111256o212be3e4tcefb6decf2e136e0@mail.gmail.com>
Date: Tue, 11 Sep 2007 15:56:33 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v2] Move the definition of pr_err() into kernel.h
Cc: "Emil Medve" <Emilian.Medve@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, i2c@lm-sensors.org,
       linux-omap-open-source@linux.omap.com
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32903925779@orsmsx414.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11895344211267-git-send-email-Emilian.Medve@Freescale.com>
	 <D5C1322C3E673F459512FB59E0DDC32903925779@orsmsx414.amr.corp.intel.com>
X-Google-Sender-Auth: 6a59518bf9465216
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/11/07, Waskiewicz Jr, Peter P <peter.p.waskiewicz.jr@intel.com> wrote:
<snip>

> > -#define pr_err(fmt, arg...)  printk(KERN_ERR DRIVER_NAME ":
> > ", ## arg);
> > -
>
> Unnecessary whitespace removal.

Actually... I prefer removing the extra blank-line... it's easier to
read and keeps on blank-line only to separate other
defines/code-portion

Same to all the others

<snip><snip><snip><snip><snip>

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
