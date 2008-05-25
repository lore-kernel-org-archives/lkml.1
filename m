Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYEYJFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYEYJFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYEYJEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:04:51 -0400
Received: from deliver.hol.gr ([62.38.3.204]:34768 "EHLO deliver.hol.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYEYJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:04:50 -0400
From: "P. Christeas" <p_christ@hol.gr>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Patch: usblp quirk for zebra printers
Date: Sun, 25 May 2008 12:03:45 +0300
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, twaugh@redhat.com
References: <200805212057.52050.p_christ@hol.gr> <20080521153756.cc701b14.zaitcev@redhat.com>
In-Reply-To: <20080521153756.cc701b14.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251203.49033.p_christ@hol.gr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Pete Zaitcev wrote:
> On Wed, 21 May 2008 20:57:49 +0300, "P. Christeas" <p_christ@hol.gr> wrote:
> > I guess such a quirk may be a little odd, but it has been a blocking
> > point in my system not being able to support more than one printer.
> Personally, I don't like this. In kernel, we typically try not to
> fake things in lower levels in order to fool upper levels. 
>...
> I'm cc-ing this to Tim Waugh.

I'm now working in a more "politically correct" way around that issue [1]. The 
outline is that we _add_ a backend to CUPS[2], which will bring back USB 
addressing by /dev/.. name. Then, we could implement udev rulesets which will 
create "by-id" symlinks to the usblpX devices. 
My work is at github under "cups-usbbackend".


[1] it is a blocking point for my business, as I cannot attach a second 
printer.
[2] it could remain a complementary package until we really agree we want that 
code mainline.
