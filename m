Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYJ3XKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYJ3XKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYJ3XK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:10:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:49311 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753022AbYJ3XK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:10:26 -0400
Date: Fri, 31 Oct 2008 00:10:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: hid: struct device - replace bus_id with dev_name(),
 dev_set_name()
In-Reply-To: <1225395316.21973.47.camel@nga.site>
Message-ID: <alpine.LNX.1.10.0810310009110.31273@jikos.suse.cz>
References: <1225385705.21973.20.camel@nga.site>  <490A0A35.9060606@gmail.com> <1225395316.21973.47.camel@nga.site>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Kay Sievers wrote:

> > > switch over to the new api, which will remove the 20 bytes array
> > > and does no longer have a size limitation.
> > Cool!
> > Could you left the comment above to remind us about removing this ugly hack
> > later when the new non-limited api will be used?
> Sure!
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: hid: struct device - replace bus_id with dev_name(), dev_set_name()

Hi Kay,

thanks for this cleanup. What is the timeframe the bus_id will be removed 
from struct device?

-- 
Jiri Kosina
SUSE Labs
