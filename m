Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZGPEGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZGPEGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZGPEGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:06:33 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:38628 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZGPEGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QlzB292NfWDA6li8Kasgk5OL1cIZAxqut3D5tmR/PEbZuhESz0by9loh6v5MnCufUr
         Km0oDQs9bllq3UnSJzNY4FlFiN3IXFqPpHS3LnuzZsvzduYcdwCSK7nlNma8LaDmW5E/
         65AzHS7GdKwaWxZKbHlzbFluHdI56/OzoT6+8=
MIME-Version: 1.0
In-Reply-To: <20090716040225.GA31064@kroah.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714161514.GA2026@kroah.com>
	 <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
	 <20090716040225.GA31064@kroah.com>
Date: Thu, 16 Jul 2009 14:06:32 +1000
Message-ID: <21d7e9970907152106t6747c41fi6c999a96a13e4cfd@mail.gmail.com>
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 2:02 PM, Greg KH<greg@kroah.com> wrote:
> On Thu, Jul 16, 2009 at 01:54:42PM +1000, Dave Airlie wrote:
>> On Wed, Jul 15, 2009 at 2:15 AM, Greg KH<greg@kroah.com> wrote:
>> > Minor comment:
>> >
>> >> +#ifdef DEBUG
>> >> +     printk(KERN_DEBUG "%s\n", __func__);
>> >> +#endif
>> >
>> > You should just use 'dev_dbg() for any debugging statments like this.
>> > You can turn them on and off dynamically, and you get all of the proper
>> > device information as to what is going on automatically.
>> >
>> > Plus, there's no need for a #ifdef in the code, which is generally
>> > frowned apon in .c files.
>> >
>>
>> We don't have a device in this case, vga arb is more of an abstraction than
>> an actual device.
>>
>> I suppose if we were feeling crazy we could add a platform device for it.
>
> No, then use the debug_printk() functions, so that you tie into the
> kernel-wide debug message system.  Please don't roll your own anymore,
> there is no need to.

Ah I assume you mean pr_devel and friends.

Dave.

>
> thanks,
>
> greg k-h
>
