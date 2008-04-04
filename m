Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbYDDPXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbYDDPXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYDDPWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:22:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:34620 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYDDPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xJr3eLTbzy0mmSPqd8kERkzj4eXKqx2PHiQJ0TF/x7orPbhjiaTU+XoO3fkVnjZ6VtR99XRlGE9JClT+Vy6RK49BLvMNX3UoicD+2Ll3cO1+YaKdXAX2cuVZoJs/I7Lk33a9pa1v5VyZ/9vgXzEyojpfM+qP7HgLJ6+e67wXplA=
Message-ID: <b6c5339f0804040822u12fb0aaclb8991fb2f6c11dbd@mail.gmail.com>
Date: Fri, 4 Apr 2008 11:22:52 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: ASUS ScreenDuo
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Alan Stern" <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1207320911.3438.19.camel@skunk.anacadf.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
	 <1207251545.24007.3.camel@bip.parateam.prv>
	 <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
	 <20080403212427.GE24239@csclub.uwaterloo.ca>
	 <b6c5339f0804040737k38839c71l19972e73325a48c4@mail.gmail.com>
	 <1207320911.3438.19.camel@skunk.anacadf.mentorg.com>
X-Google-Sender-Auth: 26808a54d3dc96b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2008 at 10:55 AM, Xavier Bestel <xavier.bestel@free.fr> wrote:
>  > If it is supposed to implement the MS SideShow API, then that would be
>  > the .NET VM (i.e. C#).  My 10 second googling turned up some info about
>  > that but I couldn't find a definition of how the hardware interface
>  > for such devices is supposed to work.  There's some XML-laden software
>  > API but it seemed to be transport agnostic.
>
>  Wouldn't there be at least 2 interfaces to the device ?

Who knows, they could have a almost-mass-storage protocol layer that
recognizes proprietary stuff in the URBs.  It could be as simple as:

 - User clicks 'synchronize' in some windows app
 - Device driver on host does some magic to make Asus device pretend like
   removable media was inserted
 - Vista sees the new device, mounts it
 - App copies C# classes and XML files to special directories on the device
 - App ejects device

Does the screen turn on or is that software controlled too?

This is pure wild guessing since I have no clue about SideShow or this
device.  Anyway it would be hard to proceed without capturing a trace
or managing to find some docs somewhere.

-Bob
