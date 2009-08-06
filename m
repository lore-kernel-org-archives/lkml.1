Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZHFT5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZHFT5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZHFT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:57:16 -0400
Received: from kroah.org ([198.145.64.141]:55330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585AbZHFT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:57:05 -0400
Date: Thu, 6 Aug 2009 12:55:05 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: Is anyone maintaining (or even using) usbtmc?
Message-ID: <20090806195505.GB29723@kroah.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
 <20090803212015.GC28579@kroah.com>
 <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
 <cb0375e10908031501w610d1e27ya69d7c2011f93555@mail.gmail.com>
 <cb0375e10908031600v4db81c51hd98094ef9a0a5a16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb0375e10908031600v4db81c51hd98094ef9a0a5a16@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 07:00:47PM -0400, Andrew Lutomirski wrote:
> On Mon, Aug 3, 2009 at 6:01 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> > On Mon, Aug 3, 2009 at 5:49 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> >> On Mon, Aug 3, 2009 at 5:20 PM, Greg KH<greg@kroah.com> wrote:
> >>> On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
> >>>> Hi all-
> >>>>
> >>>> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
> >>>> have), and it sort of works, but it seems to be both extremely buggy
> >>>> and missing a good deal of rather important functionality.  Is there
> >>>> anyone maintaining it?
> >>>
> >>> Yes, me.
> >>>
> >>>> If the answer is yes, I can describe the bugs (logspam, spurious
> >>>> errors, delayed messages, inability to read status, etc.) in greater
> >>>> detail.
> >>>
> >>> Please do, but also please use the latest version, in 2.6.30.3, we fixed
> >>> some bad problems in it recently.
> >>
> >> I am.
> >>
> >> Almost anything I do triggers this:
> >>
> >> usbtmc 3-1:1.0: Unable to read data, error -110
> >>
> 
> My N9310A is now totally wedged.  Anything I can think of doing (send
> queries, send *RST, or any of the CLEAR ioctls) fails and spews stuff
> like this:
> 
> [360946.881771] usbtmc 3-1:1.0: Unable to send data, error -110
> [360946.890770] usbtmc 3-1:1.0: usb_bulk_msg returned -110
> [360965.303400] usb 3-1: usb_control_msg returned -110
> [360965.312404] usb 3-1: usb_control_msg returned -110
> [361052.364626] usbtmc 3-1:1.0: usb_bulk_msg returned -110
> [361055.114579] usbtmc 3-1:1.0: Unable to send data, error -110
> [361055.123574] usbtmc 3-1:1.0: usb_bulk_msg returned -110
> 
> I'm going to leave it like this in case you want me to try something.

I really don't know, sorry.  Bad firmware on the device?

odd.

greg k-h
