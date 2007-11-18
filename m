Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbXKRPPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbXKRPPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 10:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXKRPP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 10:15:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:5137 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXKRPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 10:15:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bjE2QHEAm/ghg6s82pmXRXbRvZ1Izjwt6QhJLBNLz3YKTMnoXYprAcOri+OiqOShcu6gOFO6vqgBGbikHKxgfCkSL1CjI/24NKNqpiYMRsgTyTIEX6s1mndvf1xzjl4l2BCi9byp8XJbKsEw0dh7Nt6coDMsAh3Zy07U3jbvir8=
Message-ID: <4740570A.5030101@gmail.com>
Date: Sun, 18 Nov 2007 16:15:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: =?UTF-8?B?IlJhZmHFgiBKLiBXeXNvY2tpIg==?= <rjwysocki@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <200711181603.26522.rjw@sisk.pl> <474050EC.5080507@gmail.com> <200711181623.20029.rjwysocki@sisk.pl>
In-Reply-To: <200711181623.20029.rjwysocki@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 04:23 PM, Rafał J. Wysocki wrote:
> On Sunday, 18 of November 2007, Jiri Slaby wrote:
>> On 11/18/2007 04:03 PM, Rafael J. Wysocki wrote:
>>> Can you also make the new System-map available, please?
>> Sure:
>> http://www.fi.muni.cz/~xslaby/sklad/System.map1
> 
> The last notifier called in http://www.fi.muni.cz/~xslaby/sklad/susp_hang2.png

Last... Note, that it's only first 20 invokations of notifiers, there are
bazillion of them when I remove the condition '< 20'.

> is apparently cpu_swap_callback() which is not called in
> http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png .
> 
> Can you verify that cpu_swap_callback() gets called if the patch is not
> applied?

Does this still apply?
