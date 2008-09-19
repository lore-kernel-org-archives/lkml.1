Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYISAch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYISAch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 20:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYISAc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 20:32:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:21288 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbYISAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 20:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VhOV/dzdhiMqhqEMmaOnwu0QKRr/dUCzgcP6geJD8bQEXWpLSFMCBrEYfvxs7svdac
         OA7McSxGHC1df3D/qPbrtwkfKm4VRyT04RTjPbH8fSN8ho7BMb2vg+VJjs3yngN3Q0K7
         +pedC0f1maMsmmdXHJjf9QHV1dvSR7vfBOwwU=
Message-ID: <dd18b0c30809181732t48b41806nadb60829a4fbdd67@mail.gmail.com>
Date: Thu, 18 Sep 2008 17:32:26 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0809181818200.17483-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809172144s75bf684am951159218717972e@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809181818200.17483-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 3:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 17 Sep 2008, Justin Mattock wrote:
>
>> Hello,
>> after a bit of
>> searching I located a patch for something
>> that might be similar to this issue:(cant seem to locate the
>> linux-kernel thread).
>> http://www.gossamer-threads.com/lists/linux/kernel/966076
>> I've applied the patches just to see what would happen,
>> As for now I have not seen the Disable irq #23 yet,
>> (usually after a recompile of the kernel, upon reboot this message will appear,
>> this time it didn't). But you never know I'll run the system for a few days
>> and see if it pops up.
>
> You are concentrating on the symptom instead of the problem.  The
> symptom is that "Disabling IRQ #23" message -- don't worry about it.
>
> The underlying problem is the "ehci_hcd 0000:00:1d.7: HC died;
> cleaning up" message -- it should _never_ appear.  If you have a
> reliable way of provoking it then something needs to be fixed.
>
> Alan Stern
>
>

The reliable way of provoking this message is
when uvcvideo is loading(not the module, but the tools involved with
the communication of loading the firmware and module).
i.g. when using the udev approach with isight-firware-tools
I will receive this, but if I use the hal approach
this message does not appear. Now with using the udev approach
I did try this patch:(not knowing what it really was doing),
http://www.gossamer-threads.com/lists/linux/kernel/966076
And it seems this message has not appeared. From looking at the
situation after running this patch irregardless if it was intended for this
or not, I'm wondering if isight-firware-tools is the main issue with this
rather than the kernel.


-- 
Justin P. Mattock
