Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbYDVEa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbYDVEa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYDVEaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:30:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:53033 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYDVEaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fLBoNI/a/57cQEwZFawYEAzjdBs7cscAryteYonTpq+UgFVG9H0wh64Hq562g+qDeeKL5WTSCGntzVuvJDbrjECB5tDPxX5NkjDlJ5vCGOqvoEcBUMyZYbY5PHvCJZG8x7xOzlx6nFAi5+90bphTq6M/24VTAc7BMvbb+R+ivww=
Message-ID: <ed10ee420804212130r59833142lc031afe49107123d@mail.gmail.com>
Date: Mon, 21 Apr 2008 21:30:09 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi 3945 debug parameter should be writable via sysfs
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
	 <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com>
X-Google-Sender-Auth: ceff3df5ce97eed0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/08, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Apr 21, 2008 at 10:10 AM, SL Baur <steve@xemacs.org> wrote:
>  > Is there any reason why the debug parameter in the iwlwifi driver
>  >  should be read-only?

> it doesn't have any affect on debug output though.  This variable is
>  copied to to another one in pci proble
>  so unless you have 2 cards there is no use for it.
>  Run time debug output can be handled through debug_level sysfs entry
>  /sys/bus/pci/drivers/iwl4965/debug_level
>  Yet this will be changed as well to be per device instead of per driver

O.K.  The driver help recommended turning on debug for first time usage
and I was surprised when I didn't get any debug output.  And I see now
that /proc/bus/pci/drivers/iwl3945/debug_level *is* writable.  I'm lost in a
twisty maze of /sys directories, all subtlely different.

The driver itself works fine, but I'm having trouble getting decent speed out
of it, similar to the horrible performance I had under another operating
system, not quite as bad but still worse than a MacBook Pro.  Any clues on what
I can look for to see why it so relatively slow?  I'm going to put it to the WoW
test as soon as I can get a modern userland & Wine on the machine, it's running
RHEL 4 now.  The machine is a Lenovo T60.

-sb
