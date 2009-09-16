Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZIPCWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZIPCWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZIPCWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:22:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42304 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbZIPCWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:22:33 -0400
X-Sasl-enc: hdom9jlaXfmGN/aGJ0nrU18KnTvkkidBzN3gspL/uNZu 1253067756
Date: Tue, 15 Sep 2009 23:22:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] backlight: Provide two stage registration
Message-ID: <20090916022234.GB1627@khazad-dum.debian.net>
References: <1253031583-11286-1-git-send-email-mjg@redhat.com>
 <1253042322.30165.52.camel@dax.rpnet.com>
 <20090915192730.GA8152@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192730.GA8152@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Matthew Garrett wrote:
> On Tue, Sep 15, 2009 at 08:18:42PM +0100, Richard Purdie wrote:
> > Could we not pass an optional pointer to a properties structure to
> > create the backlight with instead or find a better way to solve this?
> 
> That'd work, but it'd involve significant refactoring of all the 
> drivers - we really need to be setting max_brightness before 
> device_register() is called. I suspect it'd be an even larger delta 
> against mainline.

rfkill has taught us that if you have parameters that MUST be properly set,
they should be required parameters for the foo_register() call...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
