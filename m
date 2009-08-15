Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbZHODCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbZHODCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 23:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbZHODCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 23:02:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:2413 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbZHODCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 23:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rrh1JE418/j1MbYNXZbKZYIMePKENUUvOlJ4SSYlJQFz+G541k/cpNyvg1R062HjWu
         e98fBdbdQS6lAgpebmXJ1qo8N0Oes7JFWeTnCJjQGtn1JVbF/Zbmb4drV9siYnx5VsMa
         Rq+tcRgDqj2shWPJRw84n03LmiX/7o00DEsmg=
Subject: Re: [patch 0/2] Winbond IR Driver - v2
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: david@hardeman.nu
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       bjorn.helgaas@hp.com, randy.dunlap@oracle.com
In-Reply-To: <20090809095645.198777507@hardeman.nu>
References: <20090809095645.198777507@hardeman.nu>
Content-Type: text/plain
Date: Sat, 15 Aug 2009 06:02:27 +0300
Message-Id: <1250305347.18122.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-09 at 11:56 +0200, david@hardeman.nu wrote:
> Here's a new patch set which should replace all the patches currently in the
> -mm tree for the winbond cir driver. The new series incorporate feedback from
> Bjorn Helgaas (convert the driver from ACPI to PNP) and Randy Dunlap (Kconfig
> fixes).
> 
> The IR decoding can still be improved but the driver works for in daily use
> decoding RC6 commands, so I believe it is ready to go upstream.
> 

Hi.

As I understand, this hardware returns sampled IR signal, so it can be
used with any remote, right?

Then why not to implement lirc driver?

This driver as I understand is a driver for single remote shipped with
the notebook.

I have recently wrote a lirc driver for  my receiver, a lirc driver. Now
I can use all my remotes.

And no, I don't need any software support for that. LIRC happily
forwards all events via uinput to kernel, so I use it a an ordinary
keyboard.

Best regards,
	Maxim Levitsky

