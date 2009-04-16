Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZDPM1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZDPM1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZDPM06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:26:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60160 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754065AbZDPM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:26:57 -0400
Date: Thu, 16 Apr 2009 13:27:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, devzero@web.de,
       linux-kernel@vger.kernel.org
Subject: Re: Should MODULE_DESCRIPTION be mandatory ?
Message-ID: <20090416132752.0865f718@lxorguk.ukuu.org.uk>
In-Reply-To: <49E65117.7020309@oracle.com>
References: <671646821@web.de>
	<20090415194226.GB25783@uranus.ravnborg.org>
	<49E64E86.4080109@oracle.com>
	<20090415212138.GB27597@uranus.ravnborg.org>
	<49E65117.7020309@oracle.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see 424 modules without MODULE_DESCRIPTION (in the list above) and
> 3127 .c files that contain "MODULE_DESCRIPTION".
> 
> To me it's a Nice to have but not Required.  (i.e., not worth it IMO)

I think it is worth doing but we certainly don't want it warning by
default yet - warning people who choose to work on this is useful
until but until there are only a few offenders left spewing a zillion
warnings won't help
