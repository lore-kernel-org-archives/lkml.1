Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZKZFV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZKZFV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZKZFVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:21:55 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38762 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZKZFVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=siuvncoSeXKvkXKVl9bqT0SPjK4ydQHxpjVKag61WdQ9qgh7j4qoWDOZ2FLzPErEMb
         1g0/ZY197NbkBFdTxPwI9R6b3d14WoVsh2bWjRR5daDik6uYg6ZLjC2oCT5JZNGeEUbP
         b47XK23y65zGXy4Ww+rMPWdAFkzb4GcHpjeas=
Date: Wed, 25 Nov 2009 21:21:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
       Mario Limonciello <superm1@ubuntu.com>, linux-input@vger.kernel.org,
       linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126052155.GD23244@core.coreip.homeip.net>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <m3r5rpq818.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r5rpq818.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 09:51:31PM +0100, Krzysztof Halasa wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> > Curreently the "scan" codes in the input layer serve just to help users
> > to map whatever the device emits into a proper input event code so that
> > the rest of userspace would not have to care and would work with all
> > types of devices (USB, PS/2, etc).
> >
> > I would not want to get to the point where the raw codes are used as a
> > primary data source.
> 
> The "key" interface is not flexible enough at present.
> 

In what way the key interface is unsufficient for delivering button
events?

-- 
Dmitry
