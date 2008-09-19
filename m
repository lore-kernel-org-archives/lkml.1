Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYISQmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYISQmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYISQl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:41:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41069 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYISQl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n2qC0FiEnlCxt1MEjQVT3X5BAU5hZ0nx6ibUfUfIzmTbSiHABm8ed1jIPb+ZCUeVkC
         lEJzGPTUweg1aEkt/2sRTGQRN3/8JHDq1HP9V7ApY14aAnSRuTBRio3WatjggwBx15ho
         3v2/CvGfzKCwuhxlK9msVLYUCNL5obbpIP2gw=
Message-ID: <dd18b0c30809190941g8b44175haf3e3a7c354fe01c@mail.gmail.com>
Date: Fri, 19 Sep 2008 09:41:55 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0809191206390.2429-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809181732t48b41806nadb60829a4fbdd67@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809191206390.2429-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 9:08 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 18 Sep 2008, Justin Mattock wrote:
>
>> > You are concentrating on the symptom instead of the problem.  The
>> > symptom is that "Disabling IRQ #23" message -- don't worry about it.
>> >
>> > The underlying problem is the "ehci_hcd 0000:00:1d.7: HC died;
>> > cleaning up" message -- it should _never_ appear.  If you have a
>> > reliable way of provoking it then something needs to be fixed.
>> >
>> > Alan Stern
>> >
>> >
>>
>> The reliable way of provoking this message is
>
> Which message?  The "Disabling IRQ #23" message or the "HC died;
> cleaning up" message?
>
>> when uvcvideo is loading(not the module, but the tools involved with
>> the communication of loading the firmware and module).
>> i.g. when using the udev approach with isight-firware-tools
>> I will receive this, but if I use the hal approach
>> this message does not appear. Now with using the udev approach
>> I did try this patch:(not knowing what it really was doing),
>> http://www.gossamer-threads.com/lists/linux/kernel/966076
>> And it seems this message has not appeared. From looking at the
>> situation after running this patch irregardless if it was intended for this
>> or not, I'm wondering if isight-firware-tools is the main issue with this
>> rather than the kernel.
>
> It doesn't matter what tools or other userspace programs you run; the
> "HC died; cleaning up" message should _never_ appear.
>
> Alan Stern
>
>

The disable irq #23 message.

As for the HC died; cleaning up
(where did you see that, can't seem to find that?)


-- 
Justin P. Mattock
