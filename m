Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYJ3FQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYJ3FQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYJ3FP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:15:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:54754 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYJ3FP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dmzFkQqEM2wq8w7A3bQTyNnq0TshwgoLohHbALUqSC4W7EU+w9GVJilLXYUYIcFKiy
         DG39mhCTqL7Cs0I85N54abNS29m2PYnUfOrucIAS+G0yyrfvQ+9XzsUXA6ASOBLmpPpk
         rqQQt4efNBSuNYbz3CIxsc2KGz5hT6O7Mhvj8=
Subject: Re: mmc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Pierre Ossman <drzeus@drzeus.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <C4E7021A-E5BA-4204-BDC1-D2DCA8CCEE1A@holtmann.org>
References: <1225329600.5970.72.camel@nga.site>
	 <1225331284.5496.12.camel@brick>
	 <C4E7021A-E5BA-4204-BDC1-D2DCA8CCEE1A@holtmann.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 22:15:54 -0700
Message-Id: <1225343754.5496.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 05:37 +0100, Marcel Holtmann wrote:
> Hi Harvey,
> >
> > A lot of these helpers don't seem to add that much, would you care for
> > a patch removing them Pierre?
> >
> > Specifically sdio_func_id, sdio_get/set_drvdata don't have that many
> > users.
> 
> I prefer if we keep them. Since they take the proper parameter.  
> Otherwise the driver has to always got func->dev for everything. Most  
> SDIO drivers care of the function and not about the struct device  
> underneath it.
> 

Sure, it just seemed odd to have a wrapper around a wrapper.

Cheers,

Harvey

