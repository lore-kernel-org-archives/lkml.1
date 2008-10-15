Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYJOUWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYJOUWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYJOUWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:22:01 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:41474 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYJOUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:22:01 -0400
Message-ID: <48F650E3.8040805@fr.ibm.com>
Date: Wed, 15 Oct 2008 22:21:55 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Blunck <jblunck@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bharata@linux.vnet.ibm.com
Subject: Re: union mount status
References: <48F51B6C.2080000@fr.ibm.com> <20081015191144.GJ29067@bolzano.suse.de>
In-Reply-To: <20081015191144.GJ29067@bolzano.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> On Wed, Oct 15, Daniel Lezcano wrote:
> 
>> Hi all,
>>
>> What is the status of this patchset ?
>> Bharata Rao told me, no consensus was reached yet.
>> After looking at Jan Blunk's ftp server, it looks like the latest 
>> patchset was for 2.6.25-mm1. Is anyone working on this patchset right now ?
> 
> Not that I know of.
> 
> The state is as follows: we (David Woodhouse, Bharata Rao, Erez Zadok and me)
> agreed on a more or less final version of the whiteout patches. I haven't
> posted them yet since I know that Al Viro isn't convinced of the idea that
> they are actaully necessary. 

The union mount could *very* interesting for the containers (aka 
namespaces). If you create a container, you can share the same rootfs 
between  the different containers and make a COW for each container 
writing on its own filesystem, no ? Using together the mount namespaces, 
the union mount and the ro bind mount, can be very powerful IMHO.

