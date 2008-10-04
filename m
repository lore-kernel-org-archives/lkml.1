Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYJDW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYJDW3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYJDW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:29:26 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:51138 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYJDW3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DM0i0zNUpL5RTTGwM5+WbdIpD60rKI4CwKEMz1iIPbMWCAoYQKXqL6P97+vaDw5bYW
         kRB7qcAicmkBhWtQWStPDBECyZDLXccQzPFSMCY+OYDJMoaYziJewG5IoFxUHMZNpYnB
         ImyD61rtY2s6HB3+K5SLQnR+8223O+LNn2feg=
Message-ID: <48E7EDD7.5080507@gmail.com>
Date: Sun, 05 Oct 2008 07:27:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
References: <200808290002.55026.rjw@sisk.pl> <20081004225008.2cc08201@lxorguk.ukuu.org.uk> <48E7E5B1.8010101@gmail.com> <200810050030.18814.rjw@sisk.pl>
In-Reply-To: <200810050030.18814.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 4 of October 2008, Tejun Heo wrote:
>> Alan Cox wrote:
>>>> Hm, I'm not sure what you mean exactly, but the point is to blacklist the
>>>> on-board controllers only and a devfn of the controller is needed for that,
>>>> or a part of it (like the slot number I'm using).  Could that be done above
>>>> the driver level?
>>> It can be done in one place via the libata core code I think rather than
>>> in each driver. Might need to be a helper function but you'd at least
>>> remove all the duplication.
>> I think it's better to keep the list in each LLD but having a helper in
>> libata-core would be nice.
> 
> Well, I can try to introduce one in a future patch.  Will that be OK?

Yeah, sure.  :-)

-- 
tejun
