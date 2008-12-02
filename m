Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbYLBVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYLBVUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYLBVU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:20:27 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25428 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYLBVUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:20:24 -0500
Message-ID: <4935A692.3050300@hp.com>
Date: Tue, 02 Dec 2008 16:20:18 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Jamie Lokier <jamie@shareable.org>, Andreas Dilger <adilger@sun.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: Re: Support for applications which need NFS or CIFS "share_deny"
 flags on open
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>	 <20081202193819.GJ3186@webber.adilger.int>	 <20081202200621.GA4451@shareable.org> <524f69650812021220n2b7611b9x2eb3b0b6c7ece849@mail.gmail.com>
In-Reply-To: <524f69650812021220n2b7611b9x2eb3b0b6c7ece849@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> On Tue, Dec 2, 2008 at 2:06 PM, Jamie Lokier <jamie@shareable.org> wrote:
>> The bit I find interesting is that other CIFS clients are said to
>> implement these flags.  If that means real unixes, maybe they've
>> worked out a sensible way to handle them?
> 
> I thought that MacOS uses these flags (not just Windows, and of course
> older clients too OS/2, DOS etc.).

The title of their proposal was "client"... as in not the local
filesystem, but the impression of what wine really wanted is
for local linux filesystems to implement these non-posix behaviors
so "wine apps can run just like on windows" on the local machine.

Thus the strong objection from everyone doing local filesystems.

Passing exclusive DENYREAD DENYWRITE DENYDELETE network
protocol flags from a linux client to a remote server
is an entirely different and IMO acceptible thing.

And AFAIK on unix the only local support would be by doing
a client-on-server loopback, where the server implements
these modes as best it can and you are only protected
against wine apps that are also inside the "share drive".

jim

