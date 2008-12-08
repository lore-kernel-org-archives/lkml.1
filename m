Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbYLHVKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbYLHVKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYLHVKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:10:41 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57885 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYLHVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:10:40 -0500
In-Reply-To: <493D8A8B.9090201@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Dennis Hardy <dhardy@sogetthis.com>, Greg KH <gregkh@suse.de>,
       Holger Hoffstaette <holger@wizards.de>, layton@redhat.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Subject: Re: CIFS regression in 2.6.27.8
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF3E80A64B.F15C9D0B-ON87257519.00745117-86257519.0074700A@us.ibm.com>
From: Steven French <sfrench@us.ibm.com>
Date: Mon, 8 Dec 2008 15:10:35 -0600
X-MIMETrack: Serialize by Router on D03NM123/03/M/IBM(Release 8.0.1|February 07, 2008) at
 12/08/2008 14:10:36,
	Serialize complete at 12/08/2008 14:10:36
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes - they look distinct


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com



Stefan Richter <stefanr@s5r6.in-berlin.de> 
12/08/2008 02:58 PM

To
"Rafael J. Wysocki" <rjw@sisk.pl>
cc
Pekka Enberg <penberg@cs.helsinki.fi>, Dennis Hardy 
<dhardy@sogetthis.com>, linux-kernel@vger.kernel.org, layton@redhat.com, 
Steven French/Austin/IBM@IBMUS, Greg KH <gregkh@suse.de>, 
netdev@vger.kernel.org, Holger Hoffstaette <holger@wizards.de>
Subject
Re: CIFS regression in 2.6.27.8






Rafael J. Wysocki wrote:
>> On Mon, Dec 8, 2008 at 8:18 PM, Dennis Hardy <dhardy@sogetthis.com> 
wrote:
>>> I just mounted a network drive (Windows Server) via CIFS under 
2.6.27.8, and
>>> the sizes reported by "df" are completely incorrect:
...
>>> Does anyone else see this sort of behavior with 2.6.27.8?  This worked 
fine
>>> in 2.6.27.6 (we skipped 2.6.27.7)...

There were several cifs updates in .8 but AFAIU none in .7.

> FWIW, it seems to be related to this one: 
http://lkml.org/lkml/2008/12/8/7

Holger's report is about the userland SMB/CIFS server, while Denis's is
about kernelspace client code.  They look like separate issues to me.
-- 
Stefan Richter
-=====-==--- ==-- -=---
http://arcgraph.de/sr/


