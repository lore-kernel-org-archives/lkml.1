Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZGXLDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZGXLDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZGXLDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:03:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:23284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZGXLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nye1IhowT9SWGl/vy90hBEezbNg2XzOS+DVdwSt0aVRpJqHb+IznSOAV1xTdulNahX
         Nfhu92vtv94KDKQUFCxMP2n7f4l3YU6PSGrzc25esHQM/PklXFavm3br6ukYb2wnwxam
         TYGcdcJRgJKvVpCTEf05C4bPyoo96HKDOjDRU=
Message-ID: <4A699506.4010006@gmail.com>
Date: Fri, 24 Jul 2009 13:03:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Meyer <thomas@m3y3r.de>, Parag Warudkar <parag.warudkar@gmail.com>,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
References: <1247410030.1095.1.camel@localhost> <4A5A46ED.7010907@gmail.com> <1248117834.7185.17.camel@localhost> <200907222228.18615.rjw@sisk.pl>
In-Reply-To: <200907222228.18615.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 10:28 PM, Rafael J. Wysocki wrote:
> On Monday 20 July 2009, Thomas Meyer wrote:
>> Maybe memory in acpi S3 is not so stable? Is this possible?
> 
> Generally, it is, but I haven't seen it happen yet.  In theory, if the memory
> chips are not refreshed appropriately while suspended, something like this may
> happen.

You can check it by a program from:
http://lkml.org/lkml/2008/4/24/439

Only change 1000000000 to circa 5/6 of your memory size. Suspend the
machine after "alloced" appears on the console.
