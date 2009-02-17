Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZBQWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZBQWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZBQWTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:19:18 -0500
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:43402 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750828AbZBQWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:19:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=sCb/styuBd29q/pNdO3n9xQVAmAVulUvXt4uknksBQh7MRnzrUPrAz6xmpW1865qkMwG5gvbiR4zsc+AQmJFPh46vz2z5Xx0Lx8K3LJEyAoUh9955n3L4EipNCKiB1aN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 14:19:13 -0800
User-Agent: KMail/1.9.10
Cc: mark gross <mgross@linux.intel.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902160010.16955.rjw@sisk.pl> <20090217215717.GA25605@linux.intel.com> <20090217220439.GA1573@srcf.ucam.org>
In-Reply-To: <20090217220439.GA1573@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171419.14823.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 2:04 pm Matthew Garrett wrote:
> On Tue, Feb 17, 2009 at 01:57:17PM -0800, mark gross wrote:
> > Putting the wake on key event issue aside, is it possible to have wake
> > up's on the ms time scale?  I ask because I thought the XO did exactly
> > this (but left the screen live).  Why does it take 20 sec to get into
> > or out of S3 on my laptop?
>
> Graphics reinit, dumping graphics contents back into RAM, us resuming
> devices in series, that kind of thing. On some hardware you'll spend a
> noticable amount of time in the BIOS before any of the Linux resume code
> gets touched. I thought the XO had got sub second, but I wasn't sure
> that they were in the low ms range.

IME a good chunk of it is BIOS time.  On my x200s resume is very fast (on the 
order of a second or two though I haven't measured), while on my Eee and T61 
machines it's much slower, even though they're all using Intel gfx.

Of course we should really be shooting for sub-second times or about the time 
it takes you to open your lid (or even much faster in the case of demand 
suspend/resume for servers/desktops).

-- 
Jesse Barnes, Intel Open Source Technology Center
