Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbXEPMI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbXEPMI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbXEPMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:08:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:19453 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbXEPMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eTlOyJeHu3PT3AK2Ugnqqbb1+VD+5JW349mQI2iXZue3B+zB/nD5RQ1X3IDLLIkLn/IquRKLBgQ7AaZyZFAWeNFQxKmBtuQ05F72ztz9GXAH0G4of8+QKM4W+BDT5a83frO491/FQ8WwiZ4ETmgULlcN1JMF0qgJHP5JUZd/u4Q=
Message-ID: <84144f020705160508t275cb379k71bdd21c9e7d3d6e@mail.gmail.com>
Date: Wed, 16 May 2007 15:08:15 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH] LogFS take three
Cc: "Albert Cahalan" <acahalan@gmail.com>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>, akpm@osdl.org,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Ingo Oeser" <ioe-lkml@rameria.de>,
       linux-mtd@lists.infradead.org,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       linux-fsdevel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070516111840.GB20482@mail.shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
	 <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
	 <20070516111840.GB20482@mail.shareable.org>
X-Google-Sender-Auth: 1c38ad5d0aa77850
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Jamie Lokier <jamie@shareable.org> wrote:
> Given that the filesystem is still 'experimental', I'd concentrate on
> getting it stable before worrying about immutable and xattrs unless
> they are easy.

We will run into trouble if the on-disk format is not flexible enough
to accommodate xattrs (think reiser3 here). So I'd worry about it
before merging to mainline.
