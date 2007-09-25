Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbXIYS0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbXIYS0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXIYS0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:26:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbXIYS0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:26:18 -0400
Message-ID: <46F952BD.4010009@redhat.com>
Date: Tue, 25 Sep 2007 14:26:05 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Pierre-Yves Paulus <py@idlum.be>
CC: linux-kernel@vger.kernel.org,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm links
 (mm/slab.c)
References: <46F92364.3080603@idlum.be>
In-Reply-To: <46F92364.3080603@idlum.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2007 11:04 AM, Pierre-Yves Paulus wrote:
> Hello,
> 
> Putting the bluetooth system under load (opening and closing several
> rfcomm links off several USB adapters, and transmitting data over them),
> I got the Oops below. The computer hung completely, as you can see. Just
> before, I also got those warnings.
> 
> I'm not sure if I'm providing the right and useful informations to allow
> fixing of those problems, as I'm definitely no expert. Please tell me if
> I do something the wrong way.
> 
> 

Please use CONFIG_SLUB and turn on SLUB debugging. Something is very wrong
somewhere...

