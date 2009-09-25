Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIYUSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIYUSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZIYUSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:18:12 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46280 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZIYUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:18:11 -0400
Message-ID: <4ABD25AC.30705@oracle.com>
Date: Fri, 25 Sep 2009 13:18:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC Patch] kbuild: remove -Wdeclaration-after-statement
References: <20090923094034.23512.90809.sendpatchset@localhost.localdomain> <20090923105157.GA31281@merkur.ravnborg.org>
In-Reply-To: <20090923105157.GA31281@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4ABD256C.0112:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Sep 23, 2009 at 05:38:01AM -0400, Amerigo Wang wrote:
>> I got lots of "ISO C90 forbids mixed declarations and code" warnings
>> during compile today's kernel.
>>
>> I think we can remove the gcc option '-Wdeclaration-after-statement'
>> now, since we already have C99 for 10 years. :)
> 
> This is a matter of style more than what C99 allows.
> Kernel style is to fobid this(*) so we keep the warning.

Agreed.

> (*) Based on reading several threads where this has
> been mentioned - I have no specific references to CodingStyle.

I've avoided making updates to CodingStyle lately.
Is this one needed?

Thanks,
~Randy
