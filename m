Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbYEBJRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbYEBJRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763758AbYEBJR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:17:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:17919 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763734AbYEBJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZR+lol+uAj3hqIfoOssiFXIRQ6m9zHvZFSpPRw/5IYepns/pYvhNHPMH0ETtnUKlCfMF9zhnAoHRL0iOC96pmeYgFz4dKjmbGq8J2cJEXGsXMF8XtBjXavwsUJpnF5upBNC3NH1f4OybTeC5v4dh9psCg+TbTJmM478sFBBMFgk=
Message-ID: <84144f020805020217x4d1cac41te8164006c72f96d1@mail.gmail.com>
Date: Fri, 2 May 2008 12:17:20 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
Cc: zaitcev@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, gregkh@suse.de, clameter@sgi.com
In-Reply-To: <200804241613.26557.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804212310.41729.elendil@planet.nl>
	 <20080423101123.a69e4945.zaitcev@redhat.com>
	 <84144f020804231035w3fdb10aax4b90dc4e0bc1957d@mail.gmail.com>
	 <200804232015.27257.elendil@planet.nl>
	 <200804241613.26557.elendil@planet.nl>
X-Google-Sender-Auth: b12c0674dbb42c1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 5:13 PM, Frans Pop <elendil@planet.nl> wrote:
>  I've run with the same kernel for about 6 hours today but not seen the
>  WARNING again, so the chance that I'll be able to provide additional info
>  is close to zero :-(
>  Maybe I'll have more "luck" later in the .26 cycle when I start using -rc
>  releases on a daily basis.

SLUB now dumps all the remaining objects in the cache when this
happens so you probably want to have CONFIG_SLUB_DEBUG_ON enabled just
in case you hit this again. Thanks.
