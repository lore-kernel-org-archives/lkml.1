Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYFYSQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYFYSQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYFYSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:16:34 -0400
Received: from web57914.mail.re3.yahoo.com ([68.142.236.107]:20705 "HELO
	web57914.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751250AbYFYSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:16:33 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 14:16:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=SYigeUo8v8jQtG5Z71zCAjJlG6xeYeQK1ZUX6PJNZiRavblBnE9vCXa3CZRbGwQcj4FFrENwVxOcMRzf/4Gvz/L2A8YeOYv8EvkjDlnGr0xR7F+XY8i+V6rEk5gTcQpwR3c6jk6YI+yDfuwXWCOJExJC6GqfLjoa6NxbRU+2PTE=;
X-Mailer: YahooMailWebService/0.7.199
Date: Wed, 25 Jun 2008 11:09:51 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Reply-To: henryzhang62@yahoo.com
Subject: Re: [E1000-devel] Strange problem with e1000 driver - ping packet loss
To: Robert Hancock <hancockr@shaw.ca>, vatsa@linux.vnet.ibm.com
Cc: e1000-devel@lists.sourceforge.net, greg@kroah.com,
       varunc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
In-Reply-To: <20080625143234.GB3899@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <375649.87756.qm@web57914.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vatsa,

This is not legacy mode that causes long ping time.

---henry


--- On Wed, 6/25/08, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Subject: Re: [E1000-devel] Strange problem with e1000 driver - ping packet loss
> To: "Robert Hancock" <hancockr@shaw.ca>
> Cc: e1000-devel@lists.sourceforge.net, greg@kroah.com, varunc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
> Date: Wednesday, June 25, 2008, 9:32 AM
> On Fri, Jun 20, 2008 at 08:40:47AM -0600, Robert Hancock
> wrote:
> > Looks reasonable to me.. and what does
> /proc/interrupts show with this 
> > setup?
> 
> Sorry about the delay, but here's /proc/interrupts:
> 
>            CPU0       
>   0:    1342021    IO-APIC-edge  timer
>   1:        416    IO-APIC-edge  i8042
>   6:          6    IO-APIC-edge  floppy
>   8:          1    IO-APIC-edge  rtc
>  12:      13367    IO-APIC-edge  i8042
> 169:          1   IO-APIC-level  acpi
> 177:       8882   IO-APIC-level  libata, eth1
> 185:      75633   IO-APIC-level  uhci_hcd:usb1,
> i915@pci:0000:00:02.0
> 193:          0   IO-APIC-level  uhci_hcd:usb2
> NMI:          0 
> LOC:    1341970 
> ERR:          0
> MIS:          0
> 
> 
> 
> -- 
> Regards,
> vatsa
> 
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://sourceforge.net/services/buy/index.php
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel


      
