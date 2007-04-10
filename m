Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXDJObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXDJObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030517AbXDJObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:31:22 -0400
Received: from Apollo.christiedigital.com ([65.195.57.9]:3022 "EHLO
	CDSCYPEXG01.cds.int" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030683AbXDJObV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:31:21 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Help Understanding Linux memory management
Date: Tue, 10 Apr 2007 10:31:34 -0400
Message-ID: <AD98412A5373CC4AA643D9C021922A541C4DC8@cdskitexg01.cds.int>
In-Reply-To: <461B9BED.6030208@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Help Understanding Linux memory management
Thread-Index: Acd7es4NDiiSP3jbS4ijE3xLnIAUqAAARC3w
From: "Mouawad, Tony" <Tony.Mouawad@christiedigital.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 14:31:35.0733 (UTC) FILETIME=[F144D650:01C77B7C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When vm.overcommit_memory = 2 and there appears to be about 2M of memory
readily available and about 12M of memory allocated to pagecache (this
is info gathered from /proc/meminfo) , a call to malloc(5000000) returns
NULL.  I would have expected that somehow, the call to malloc(5000000)
would request the memory in pagecache to be released for use by the app.


-----Original Message-----
From: Robert Hancock [mailto:hancockr@shaw.ca] 
Sent: Tuesday, April 10, 2007 10:15 AM
To: Mouawad, Tony
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help Understanding Linux memory management

Mouawad, Tony wrote:
> Hello,
> 
> I've been a MS Windows based programmer for a very long time and was
> recently tossed in an environment where I am developing embedded apps
on
> the m68k / Linux platform.  That makes me a Linux newbie.  I started
> asking a few questions on various IRC channels and was directed to
this
> group.  So, I will start asking:
> 
> These are questions derived from observations on the MCF 5475 CPU
> running Linux 2.6.10 built for the m68k platform.  Disk swapping is
> disabled.
> 
> 1) When physical memory runs low, the memory manager will try to use
> memory currently allocated to the pagecache.  Is this true?

Yes.

> 2) When vm.overcommit_memory = 2 (overcommit disabled), and memory
runs
> low, it appears that the memory manager does not try to use memory
> currently allocated to pagecache.  Is this true?

Shouldn't be, what makes you think this is happening?

> 3) Is it possible to disable the pagecache?

Not as far as I know, it's unlikely this would be of any benefit.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

