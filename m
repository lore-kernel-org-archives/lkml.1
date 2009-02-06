Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZBFA1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZBFA1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZBFA10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:27:26 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:29002 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbZBFA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=OoVBRWKyVZJMOV6xYB6Y4mBvvQMyA0QVdPVTd/bWM2TnGY0FCCtQ01KYLJHHVztMeo
         19uMyHJCJNPYiwFHfLDIfYb6NprbpJJIyhdHU31MHVpFs8n0BY6ummn407wbjCQ5FMJ5
         CELX6zbm+Q0uXrY7dq9Vr4eANaPUBD6TbqWQ0=
Message-ID: <498B83EA.4040608@gmail.com>
Date: Thu, 05 Feb 2009 18:27:22 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Vira <sri1369_s@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Mapping non-page aligned data to user
References: <305692.9769.qm@web33402.mail.mud.yahoo.com>
In-Reply-To: <305692.9769.qm@web33402.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vira wrote:
> Hi, 
> 
> Is there a way to map a non-page aligned kernel physical address to user virtual address? remap_pfn_range and vm_insert_page operate only on page-aligned physical addresses.
> 
> If there is no such support, would it be too complicated to try out
> writing something on my own to map non-page aligned addresses (the data
> size is under my control - so I can make that a multiple of page size)?
> 
> Any suggestions appreciated.

The CPU, and therefore the kernel, couldn't ensure that the user doesn't 
write outside the mapped region of kernel memory if it's not page 
aligned (the access control is page granularity only). That seems like 
it would be a show-stopper in most cases.

What exactly is it you're trying to achieve with this?
