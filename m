Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZBRPqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZBRPqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZBRPqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:46:06 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:35531 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZBRPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <20090218152913.GA26448@suse.de>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <20090218152913.GA26448@suse.de>
Date: Wed, 18 Feb 2009 08:46:02 -0700
Message-ID: <fa686aa40902180746i12af8495oe7fe676ade739bd2@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 8:29 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Feb 18, 2009 at 08:11:34AM -0700, Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> I find myself using the pattern of device_add_attributes() and
>> device_remove_attributes() frequently in my drivers.  Rather than
>> reinventing the wheel every time, I'm floating this patch to export
>> the symbols to see how it is received.  If this looks okay then I'll
>> rework my drivers and post additional patches to use these functions.
>
> No objection from me, as long as the symbols are EXPORT_SYMBOL_GPL(),
> like the rest of the driver core.  Is that ok with you?

Fine by me.  I'll rework the patch.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
