Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZGPDyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZGPDyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZGPDyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:54:46 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:55409 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbZGPDyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tzBUlk+/2Ck7D3WKfSkPQmqxYIV7x5iM28DUEN8UqIIkDVanRN9gULzw31A0oEv+gS
         SosQKKZKGDm0wRKdOaxAwN1CEKdmwaSlj71lkB5cMYvwWyq5ezB7eazZ3/57i610ukFL
         52rYatMsXUMFEuAslJZFGmkF/dgutJiCNKi5U=
MIME-Version: 1.0
In-Reply-To: <20090714161514.GA2026@kroah.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714161514.GA2026@kroah.com>
Date: Thu, 16 Jul 2009 13:54:42 +1000
Message-ID: <21d7e9970907152054q61c9bf75x836b4b644ec22a00@mail.gmail.com>
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

On Wed, Jul 15, 2009 at 2:15 AM, Greg KH<greg@kroah.com> wrote:
> Minor comment:
>
>> +#ifdef DEBUG
>> +     printk(KERN_DEBUG "%s\n", __func__);
>> +#endif
>
> You should just use 'dev_dbg() for any debugging statments like this.
> You can turn them on and off dynamically, and you get all of the proper
> device information as to what is going on automatically.
>
> Plus, there's no need for a #ifdef in the code, which is generally
> frowned apon in .c files.
>

We don't have a device in this case, vga arb is more of an abstraction than
an actual device.

I suppose if we were feeling crazy we could add a platform device for it.

Dave.
