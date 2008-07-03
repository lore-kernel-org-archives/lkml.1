Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYGCPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYGCPN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYGCPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:13:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54083 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYGCPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:13:16 -0400
Date: Thu, 3 Jul 2008 08:09:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       robfitz@273k.net, jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
 leak, removed work struct, device data struct introduced
Message-Id: <20080703080956.723a116b.randy.dunlap@oracle.com>
In-Reply-To: <20080702005355.8da89ef7.akpm@linux-foundation.org>
References: <1214653629.10495.11.camel@alnilam>
	<20080701155925.a4c00a8e.akpm@linux-foundation.org>
	<1214984799.11086.6.camel@alnilam>
	<20080702005355.8da89ef7.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 00:53:55 -0700 Andrew Morton wrote:

> On Wed, 02 Jul 2008 09:46:39 +0200 Henrik Rydberg <rydberg@euromail.se> wrote:
> 
> > On Tue, 2008-07-01 at 15:59 -0700, Andrew Morton wrote:
> > > > Subject: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource leak, removed work struct, device data struct introduced
> > > 
> > > hm, I wonder where [002/002] went.
> > 
> > Thank you very much for your comments, I will return shortly with a new
> > version. I did not fully grasp, from reading
> > Documentation/SubmitPatches, how the numbering in the subject should
> > work; when I submit my new version in reply to your mail, should I
> > submit a complete patch against the vanilla kernel, with number 001/003?
> > 
> 
> no....
> 
> The sequence numbering is only used when you're sending two or more

related, dependent,

> patches at the same time.  It is used so that the recipient can work
> out what order they are to be applied in (they can get reordered in
> flight) and so that the recipient can verify that none were missed.
> 
> So for a single patch, don't include it at all.

For multiple unrelated patches, sequence numbering could even be confusing
to recipients.  Could make them think that they missed some patch(es)
when they didn't.


> Also, it is better to prepare 2.6.27 patches against linux-next, as
> that is the candidate 2.6.27 tree.  But in the case of a brand new
> driver it doesn't matter a lot.  Unless you're using some interface
> which we've gone and changed, but that's fairly uncommon.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
