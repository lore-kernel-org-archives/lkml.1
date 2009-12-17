Return-Path: <linux-kernel-owner+w=401wt.eu-S965251AbZLQPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251AbZLQPnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965192AbZLQPnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:43:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965190AbZLQPnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:43:10 -0500
Message-ID: <4B2A518B.1030800@redhat.com>
Date: Thu, 17 Dec 2009 16:43:07 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 Thunderbird/3.0
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Greg KH <greg@kroah.com>, Zdenek Kabelac <zkabelac@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
 debug	warning
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com> <20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com> <20091216174632.GA12473@kroah.com> <4B29299B.5080704@redhat.com> <20091217003021.GB3512@kroah.com>
In-Reply-To: <20091217003021.GB3512@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 01:30 AM, Greg KH wrote:
> On Wed, Dec 16, 2009 at 07:40:27PM +0100, Milan Broz wrote:
>> On 12/16/2009 06:46 PM, Greg KH wrote:
>>> You will find that all of these are modules, right?  That's being worked
>>> on still.
>>
>> probably. I see that this implementation is in kernel since import to git...
> 
> And you will also note that I didn't paper over the issue by trying to
> provide an empty release function :)

Alasdair, can we request revert of that last patch for now
(which introduced the empty release function)?

Milan
