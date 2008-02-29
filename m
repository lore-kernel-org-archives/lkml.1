Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYB2SCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYB2SCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYB2SCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:02:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775AbYB2SCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:02:38 -0500
Message-ID: <47C84873.4040208@redhat.com>
Date: Fri, 29 Feb 2008 13:01:23 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ioan Ionita <opslynx@gmail.com>
CC: drago01 <drago01@gmail.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Reexport init_mm ?
References: <f6ca9fed0802270029l231c6050sefd90ec2997eda37@mail.gmail.com>	 <47C6617D.1030700@redhat.com> <df47b87a0802290526h322b5cc6va9621e7329d1ac98@mail.gmail.com>
In-Reply-To: <df47b87a0802290526h322b5cc6va9621e7329d1ac98@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioan Ionita wrote:
> On Thu, Feb 28, 2008 at 9:23 AM, Chris Snook <csnook@redhat.com> wrote:
>> drago01 wrote:
>>  > init_mm is no longer exported in 2.6.25, because there are no in tree
>>  > modules that use it.
>>  > But the closed sources nvidia drivers are using it.
>>  > Is it possible to reexport this symbol to let the driver work with this kernel?
>>
>>  The fact that there are no in-tree modules that use init_mm is rather
>>  compelling evidence that it's not a necessary part of the kernel module
>>  API.  Nvidia needs to fix their code.  If this is a burden, perhaps they
>>  should publish their code under a GPLv2-compatible license so we can
>>  show them how to do it.
> 
> Publish it and get it merged so you'd have no choice but to keep the
> symbol exported in the first place?

High-performance graphics developers are pretty much the last people on 
earth I want to see writing code that calls init_mm.  These people 
patent their bugs, rather than fixing them, when they turn out to make 
things go a little faster and generate "mostly correct" results.  I 
think we have a lot to teach them about kernel driver development, 
including how to get by without init_mm being exported.

	-- Chris

