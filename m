Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbXHCMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbXHCMeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbXHCMeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:34:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:27043 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761210AbXHCMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rX8cWXFMBzNhP0y+mQu3WUfXWdabkaId5Qh12Tewt7fDqRAzWAuNyvrxQSYFVb3IQ0P+X42mKjwj53m5+ShmOIT3yBHu9QQ+C45CJ7+hKiztKb0FV5N1afRBze1YL51WjlzQLyNi4VTgzladHCgmo/7wlYwd/k5/SzQifce9Nl8=
Message-ID: <31e679430708030534v5a8f1c9p3eb25c9e3db48f0a@mail.gmail.com>
Date: Fri, 3 Aug 2007 08:34:06 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Rogan Dawes" <lists@dawes.za.net>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Greg KH" <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>,
       "Alan Stern" <stern@rowland.harvard.edu>
In-Reply-To: <46B31F03.80908@dawes.za.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>
	 <200708022301.08719.david-b@pacbell.net>
	 <20070803112824.GA16802@srcf.ucam.org>
	 <200708031344.03282.oliver@neukum.org>
	 <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net>
X-Google-Sender-Auth: 780bf1c3f16bde31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07, Rogan Dawes <lists@dawes.za.net> wrote:
> Matthew Garrett wrote:
> > On Fri, Aug 03, 2007 at 01:44:02PM +0200, Oliver Neukum wrote:
> >> Am Freitag 03 August 2007 schrieb Matthew Garrett:
> >>> It's certainly possible to do that, but it's also possible to have a
> >>> userspace solution that whitelists devices. The question is whether the
> >>> default kernel behaviour should be "Save power, but potentially break
> >>> some of my devices" or "Don't break my devices, but use some more
> >>> powre".
> >> If both options have drawbacks, IMHO we follow the standard, which
> >> says that devices must support suspension.
> >
> > Except that lots of hardware doesn't follow the standard in this
> > respect, otherwise we wouldn't be having this discussion. Personally, I
> > think "Will break an unknown number of devices" is a significantly
> > larger drawback than "Will consume a small quantity of additional
> > power".
> >
>
> I guess the question could be phrased:
>
> Which one is more likely to conclude at some point?
>
> That is, if we blacklist by default, we consume that additional power
> indefinitely, because it is unlikely that people will report "my machine
> uses 200mW more than I think it should", and thus we are unlikely to
> build up knowledge of exactly which devices/classes should be blacklisted.
>
> Compare that to:
>
> "My USB printer broke, guess I'd better report it to LKML".
>
> The first option is unlikely to ever reach a satisfactory conclusion,
> whereas the second one is quite likely to flush out the guilty parties
> within a relatively short time.

Even though we should be following what the specs says and find other
ways of threating the "messy" devices. A sysfs entry for
enabling/disabling autosuspend and even to add devices to blacklist
seems quite nice to me.

>
> FWIW.
>
> Rogan
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> linux-usb-devel@lists.sourceforge.net
> To unsubscribe, use the last form field at:
> https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
