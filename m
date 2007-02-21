Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXBUQR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXBUQR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422649AbXBUQR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:17:59 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:4739 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422647AbXBUQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:17:57 -0500
Date: Wed, 21 Feb 2007 17:17:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070221171737.b6592104.khali@linux-fr.org>
In-Reply-To: <20070220191142.GE16614@redhat.com>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<45D8D6AE.3000204@assembler.cz>
	<45DB0EEA.2010205@redhat.com>
	<20070220191142.GE16614@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 14:11:42 -0500, Dave Jones wrote:
> On Tue, Feb 20, 2007 at 10:08:26AM -0500, Chuck Ebbert wrote:
>  
>  > 	i2c_core
>  > 	i2c_ec
>  > 	i2c_piix4
>  > 	asus_acpi (on a Compaq???)
>  > 	sbs
> 
> Something is pulling in asus_acpi as a dependancy. I've never
> figured out what the cause is.  For a long time I was thinking
> that we had an explicit modprobe for it in an initscript, but
> grepping for it in /etc turns up zip.

How could it be, given that asus_acpi doesn't export any symbol?

-- 
Jean Delvare
