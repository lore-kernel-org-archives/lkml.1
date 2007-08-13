Return-Path: <linux-kernel-owner+w=401wt.eu-S945166AbXHMQF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945166AbXHMQF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946876AbXHMOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:33:25 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:62695 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946758AbXHMOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:33:23 -0400
Date: Mon, 13 Aug 2007 08:33:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: why use memcpy when memmove is there?
In-reply-to: <fa.tH0XPZg4jvmqSQh3iOmzbwrRN9Y@ifi.uio.no>
To: sk malik <srikrishanmalik@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Message-id: <46C06B9F.6080603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tH0XPZg4jvmqSQh3iOmzbwrRN9Y@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sk malik wrote:
> Hi, All
> 
> We were looking at  "[kernel]/lib/string.c"
> (http://lxr.linux.no/source/lib/string.c#L500)
> 
> memcpy copies a part of memory to some other location
> but It will not work for all cases of overlapping
> blocks.(if the start of destination block falls
> between the source block)
> 
> while memove copes with overlapping areas.
> 
> then why is memcpy present in the sources can't we
> simply do
> 
> "#define memcpy memmove" in include/linux/string.h
> 
> or am I missing something?

Because the assumption that the areas don't overlap means memcpy can be 
more efficient.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

