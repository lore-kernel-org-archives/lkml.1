Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbXHCGG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbXHCGG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 02:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXHCGGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 02:06:11 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:20360 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754203AbXHCGGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 02:06:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q1RgjS1p2f7niuNi1ti5800My1FOE0NuJY52K++U7fHwpGNM7hHTOhJV5nfXKv78b/waKtOWDi9XZBxhP6yuB3zhCrFxH8+y/nk5TmLyvnLHkUimebKcP3DPqvBCp7jrJtygw05CBcaYNuBHeKKCNwWhMupi7x0jGjvJCj7HAsI=  ;
X-YMail-OSG: 5mIPHxQVM1lUgVIEDj7HcE4kAp0Mv3Sz3n8c2QDZKTKTldfVHDzDa2eiqQBEBxWxVf4e2GCTvci7g4ngjaPYVb5KYq_cF8UQMY3KitjUo5X9QM6L6MLZnUTY8tFp.XQS.YzSe.Fj2zHdww--
From: David Brownell <david-b@pacbell.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Thu, 2 Aug 2007 23:06:08 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <20070803011505.GA32589@suse.de> <20070803014756.GA10392@srcf.ucam.org>
In-Reply-To: <20070803014756.GA10392@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708022306.08410.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007, Matthew Garrett wrote:
> The main 
> concern I have is that kernel developers just don't tend to be the sort 
> of people that use webcams, printers or scanners, so we're relying on 
> normal users to go to the effort of reporting that their device has 
> stopped working.

True, that rather suggests that some more desktoppy (that's now a word!)
people should get involved.  Folk who know how to minimize that pain.

Sometimes when I plug in a USB device I get a dialog asking if I want to
configure it ... surely it would be possible to have that mechanism also
consult a database (part of a distro, or on some web server) fpr info
about the device, and offer the option for to poke at the device a bit to
see if it behaves.  That stuff works for music CDs; why not USB devices?

- Dave

