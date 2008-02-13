Return-Path: <linux-kernel-owner+w=401wt.eu-S1765918AbYBMIXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765918AbYBMIXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYBMIXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:23:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:20679 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbYBMIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JZRAN4LIJ1fX2jt09BBMZ47IggMUSX6j8xIQ3D3cdIm2vbDNaEWtpCQWHt7D6YMURxqxZPmExwQ6PM0bpPl+ThajFbTgqMTy+vWpM42guajVWBYPsXdZTHuV8MX3W7j57fU9FC7EUtqYx7yQDdiMIR/4wOynh4HQel2StgI4zEQ=
Message-ID: <b6a2187b0802130023m2fba0688u5ab7d4e80f2f1139@mail.gmail.com>
Date: Wed, 13 Feb 2008 16:23:11 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Cc: "Frans Pop" <elendil@planet.nl>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20080212235442.005aea9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802111623.38478.elendil@planet.nl>
	 <200802122139.14840.elendil@planet.nl>
	 <20080212205622.GA21986@suse.de>
	 <200802122245.09444.elendil@planet.nl>
	 <20080212235442.005aea9e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 3:54 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 12 Feb 2008 22:45:09 +0100 Frans Pop <elendil@planet.nl> wrote:
>
> > Symptom is that the system shuts down normally and completely, it just does
> > not power off.
>
> I've been struggling with an identically-manifesting regression on one of
> my test machines for a week.  It's due to softlockup changes, and setting
> CONFIG_DETECT_SOFTLOCKUP=n "fixes" it.

I don't have CONFIG_DETECT_SOFTLOCKUP defined in .config and there's
not option using menuconfig to select this.

I don't know whether my problem is related or not on Lenovo X60s. I
can power-off on shutdown and suspend-to-ram, but screen turns green,
and doesn't power-off on suspend-to-disk. I've to manually press and
hold the power switch to switch off. System is able to resume later.
It was working as recent as last week, but something changed past few
days.


Jeff.
