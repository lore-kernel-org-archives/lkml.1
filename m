Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZCLHSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZCLHSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZCLHSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:18:44 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:44391 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbZCLHSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:18:44 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 03:18:40 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Date: Thu, 12 Mar 2009 08:12:44 +0100
Message-ID: <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
In-Reply-To: <20090311170840.2f136849.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
thread-index: AcmipwUs1nDNQyMFSdOfnFQyuCrzDwAOl1sg
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk> <20090311170840.2f136849.akpm@linux-foundation.org>
From: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
Cc: <torvalds@linux-foundation.org>, <peterz@infradead.org>,
       <dhowells@redhat.com>, <uclinux-dev@uclinux.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2009 07:12:56.0861 (UTC) FILETIME=[F7FC2CD0:01C9A2E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Mar 2009 15:30:35 +0000
> David Howells <dhowells@redhat.com> wrote:
>> From: Enrik Berkhan <Enrik.Berkhan@ge.com>
>> 
>> The solution is to mark the pages dirty at the point of allocation by
>> the truncation code.
> 
> Was there a specific reason for using the low-level SetPageDirty()?

No, no specific reason. It was just my first try of a fix after spotting 
the problem. After a short discussion with David, we decided to wait for 
others' comments on using the low-/high-level approach.

Enrik
