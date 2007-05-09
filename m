Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbXEIKQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbXEIKQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXEIKQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:16:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62004 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbXEIKQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ts5fGeu302Teje9LAXy1V7QF0HBoRwe9wDqqNqxJCYTV8IzfbQIEKxvhytRJNjDJUJfTT8uCa07hdwuteIiJMMwHaepAo39zAYmuoIQEvHAF6o8Uts8tT2ccFXs396lEAvmG555JEj1Dmd2UwalPpzVVLw2tr5pd3KI1NNiqMig=
Message-ID: <84144f020705090316o5e3b6d89r74638ec8e4d396d4@mail.gmail.com>
Date: Wed, 9 May 2007 13:16:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch 2/9] lguest: the guest code
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, jeremy@goop.org
In-Reply-To: <200705090951.l499pYBV020391@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705090951.l499pYBV020391@shell0.pdx.osdl.net>
X-Google-Sender-Auth: 1f8d925edf39bf39
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 5/9/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> +static void add_lguest_device(unsigned int index)
> +{
> +       struct lguest_device *new;
> +
> +       lguest_devices[index].status |= LGUEST_DEVICE_S_ACKNOWLEDGE;
> +       new = kmalloc(sizeof(struct lguest_device), GFP_KERNEL);
> +       if (!new) {
> +               printk(KERN_EMERG "Cannot allocate lguest device %u\n", index);
> +               lguest_devices[index].status |= LGUEST_DEVICE_S_FAILED;

[snip]

Any reason why we don't return an error here?
