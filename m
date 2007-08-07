Return-Path: <linux-kernel-owner+w=401wt.eu-S938130AbXHGWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938130AbXHGWGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935568AbXHGVn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:43:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935433AbXHGVnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:43:25 -0400
Message-ID: <46B8E773.5020406@redhat.com>
Date: Tue, 07 Aug 2007 17:43:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org>
In-Reply-To: <46B8D984.7040602@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 04:43 PM, Jeff Garzik wrote:
> Chuck Ebbert wrote:
>> With no other changes but a kernel upgrade, the pcspkr driver
>> doesn't load automatically anymore. No changes to that driver
>> jump out, so where else could the problem be? Something to
>> do with the device class changes maybe?
> 
> This has long been a problem for me on Fedora, long before 2.6.22.  I
> would never ever have the glorious system beeps, unless I built the
> module into my kernel.
> 
> I would look into distro areas and see why it's not getting loaded.
> 

Seems to be some kind of udev / hal magic loading it. With 2.6.20/21
it worked for most people, now it seems totally broken. Maybe we should
just load it unconditionally.
