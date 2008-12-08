Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYLHU7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYLHU7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYLHU7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:59:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54723 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYLHU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:59:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <493D8A8B.9090201@s5r6.in-berlin.de>
Date: Mon, 08 Dec 2008 21:58:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Dennis Hardy <dhardy@sogetthis.com>,
       linux-kernel@vger.kernel.org, layton@redhat.com,
       Steven French <sfrench@us.ibm.com>, Greg KH <gregkh@suse.de>,
       netdev@vger.kernel.org, Holger Hoffstaette <holger@wizards.de>
Subject: Re: CIFS regression in 2.6.27.8
References: <20900699.post@talk.nabble.com> <84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com> <200812082112.49468.rjw@sisk.pl>
In-Reply-To: <200812082112.49468.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> On Mon, Dec 8, 2008 at 8:18 PM, Dennis Hardy <dhardy@sogetthis.com> wrote:
>>> I just mounted a network drive (Windows Server) via CIFS under 2.6.27.8, and
>>> the sizes reported by "df" are completely incorrect:
...
>>> Does anyone else see this sort of behavior with 2.6.27.8?  This worked fine
>>> in 2.6.27.6 (we skipped 2.6.27.7)...

There were several cifs updates in .8 but AFAIU none in .7.

> FWIW, it seems to be related to this one: http://lkml.org/lkml/2008/12/8/7

Holger's report is about the userland SMB/CIFS server, while Denis's is
about kernelspace client code.  They look like separate issues to me.
-- 
Stefan Richter
-=====-==--- ==-- -=---
http://arcgraph.de/sr/
