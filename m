Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZHNJIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZHNJIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZHNJIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:08:30 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:58874 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZHNJI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Up425oMdH5reyjhaj4zN/gt4ZniQDPhz79DeGCXMRPtqUOnHJfA42Smdqt4YFIF5Zq
         m7QIYqYthID1Sp1UbfUs3RyXqL7XT6ciKZYueNBkLCIKg6tS0hqbRfX8+GfMMzWu8NQB
         sKF0t4wzx9C0uXOfklP3uI7WlBCB4vIJlhDQQ=
MIME-Version: 1.0
In-Reply-To: <200908132256.42941.rjw@sisk.pl>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl>
	 <200908132256.42941.rjw@sisk.pl>
Date: Fri, 14 Aug 2009 18:08:29 +0900
Message-ID: <aec7e5c30908140208j1498c134j46bef043f60f6c55@mail.gmail.com>
Subject: Re: [PATCH update 2x] PM: Introduce core framework for run-time PM of 
	I/O devices (rev. 16)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 5:56 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
>
> Introduce a core framework for run-time power management of I/O
> devices.  Add device run-time PM fields to 'struct dev_pm_info'
> and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> a run-time PM workqueue and define some device run-time PM helper
> functions at the core level.  Document all these things.
>
> Special thanks to Alan Stern for his help with the design and
> multiple detailed reviews of the pereceding versions of this patch
> and to Magnus Damm for testing feedback.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I've now tested v16 with my SuperH Mobile platform device Runtime PM
implementation. All seems fine and my patches for patches for drivers
such as i2c master, fbdev, v4l2 and uio behave as expected.

Acked-by: Magnus Damm <damm@igel.co.jp>

The patch "PM: Runtime PM v15 - Platform Device Bus Support" works
well with v16 and does not need any update.

Cheers,

/ magnus
