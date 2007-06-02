Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXFBMvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXFBMvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 08:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbXFBMu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 08:50:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:52476 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331AbXFBMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 08:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ODbpRXn4cnCfgLTc/6vjcwNCJuxBCHOYe04+gkC/Pr6vvzMQiWM4aE06ad+TFfsHFJlYW81YVq4GwfaV3Q+pFA+7R+b/tr1Rc8M57HKg6fIqRWm1cLDan7+tJz5hNDHMrG2RBr37rZklw6fyOohU7yU0FHgssX+V8wjl7vmDbbo=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bastien Nocera <hadess@hadess.net>, John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <d120d5000706010945w4de3e8d9i4d43d2ae686e4d0a@mail.gmail.com>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180615994.3030.166.camel@cookie.hadess.net>
	 <1180619002.2693.35.camel@localhost.localdomain>
	 <1180626416.3469.7.camel@localhost.localdomain>
	 <d120d5000706010945w4de3e8d9i4d43d2ae686e4d0a@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 02 Jun 2007 13:50:52 +0100
Message-Id: <1180788652.2355.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 12:45 -0400, Dmitry Torokhov wrote:
> The patch was pretty good, I did not quite like the driver
> registration code so I tried to clean it up.

Cool, cheers.

> What do you think about
> the attached patch (not tested due to the lack of hardware). If you
> are OK with it please add your signed-off-by because version of the
> patch I grabbed did not have it.

Attached patch looks good - I can't test it until next week, but looks
logically correct to me. I would also like to add the oddball proc event
notification system to the removal-schedule document, but this can be a
fight for another day.

> > > Also I don't think you want to use
> > > KEY_BREAK. What is the expected function of that key?

To lock the screen. We probably want to replace HCI_HKEY_BREAK with
HCI_HKEY_LOCK, as the picture on the keys is a little padlock.

> > It's a "lock" key, I really want KEY_LOCK added to input.h, but that
> > might prove difficult. For now I've used KEY_CLEAR, yell if you think
> > there's a better one to substitute or if you guys want me to add get a
> > constant added to input.h.
> 
> Iam still struggling with the purpose of the key. What would you
> extect to happen when youser presses this key? Screen gets locked?
> KEY_SCREENLOCK? KEY_SCREENSAVER?

Either of these keys would be good to add.

So yes, patch looks good, cheers for the improvements.

Signed-off-by: Richard Hughes <richard@hughsie.com>

Thanks again,

Richard.


