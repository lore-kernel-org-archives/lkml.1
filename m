Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXHCPYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXHCPYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbXHCPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:24:45 -0400
Received: from smtp110.sbc.mail.re2.yahoo.com ([68.142.229.95]:24554 "HELO
	smtp110.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932067AbXHCPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:24:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GSDq9br0Fzvpk2UyaCJEG44pvf+OKUolkWyMPpF3HIm10nFTZ/hihtmHAFhshsrl9cZ5CDPriAE7zl9CtPdtShqO8keJIKGSX+6WqrZLwLWTpbpD/23zrYsMhWaQ080aGGyJUXURrzJlJiCE381DlKHamZ1YUb1EGueeeP6TJTg=  ;
X-YMail-OSG: s1AZo90VM1nK1PJZaqkTNhtQJm6jZQ2ZPdR1CIvqBv2YEMPT
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend =?iso-8859-1?q?by=09default_on_certain_device?= classes
Date: Fri, 3 Aug 2007 08:24:41 -0700
User-Agent: KMail/1.9.6
Cc: Dave Jones <davej@redhat.com>, Jiri Kosina <jikos@jikos.cz>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.64.0708031636160.26230@twin.jikos.cz> <20070803145321.GB17138@redhat.com>
In-Reply-To: <20070803145321.GB17138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708030824.41924.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Dave Jones wrote:
>  > We have been playing with runtime autosuspend of HID devices, are 
>  > currently postponed the full support, as it turns out that many devices 
>  > don't support this feature properly (probably due to not being tested in 
>  > Windows).
> 
> Interesting.  Which devices did you notice failing?
> Was it a case that they would sleep and not come back out of that state?

And could you elaborate on "many"?  What proportion of HID devices
(by volume, model, etc) seem to have problems?

I'd certainly expect there to be some HID devices which misbehave
(I have one, a cheap MacAlly trackball).  Early testing seemed to
indicate such misbehavior was the exception to the rule ... folk
kept disbelieving me when I pointed out some HID devices misbehaved,
since nobody else had seen such a thing!

The specific failure I saw was that the device advertised itself as
supporting remote wakeup, but it couldn't issue that signaling. It
came back from suspend just fine ... but moving or clicking would
not do what it should.

- Dave
