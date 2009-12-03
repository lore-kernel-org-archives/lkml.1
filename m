Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZLCMWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZLCMWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZLCMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:22:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:44608 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZLCMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:22:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ds58Hce+3w3qZzsS5t03HeLPB9Wsvg+uCodIVmbmH/WZ8lGhZZRoeDwE/kDR+PUee6
         L3AebZc0NaZT6PGVYjR3md+kQSOEAnA3K8S/v18nERZLg7apftSCHndp9fW3HeEWXThh
         RrF79O8GMPhdck6hA7UqAqSVkiKG5kA8S2BCA=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
Date: Thu, 03 Dec 2009 13:15:23 +0100
In-Reply-To: <20091203050810.GA26595@barra.bne.redhat.com> (Peter Hutterer's
	message of "Thu, 3 Dec 2009 15:08:10 +1000")
Message-ID: <87zl60s17o.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Hutterer <peter.hutterer@redhat.com> writes:

 Peter> These touchscreens are mounted onto HP TouchSmart and the Dell
 Peter> Studio One 19. Without a quirk they report a wrong button set
 Peter> and the x/y coordinates through ABS_Z/ABS_RX, confusing the
 Peter> higher levels (most notably X.Org's evdev driver).

What exactly does this fix? I've been using NW touchscreens for a while
and don't recall any issues (admittedly only used it with evtouch).

-- 
Bye, Peter Korsgaard
