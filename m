Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZFCPFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZFCPFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZFCPFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:05:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:62536 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbZFCPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:x-length:x-uid:content-type
         :content-transfer-encoding:message-id;
        b=UPxw4ViyJjerm3wl74xzzXDzhBa75Cf4prr4zAQvQ2nW9Hd4KD/mkZ/Gtw4t0uSqrp
         GwZyOP7drMi3bggK7VDgP2ser+lGDo4TFEDnIAwuT5M6GdHrqbTRY+uF36s0b6S7gFZf
         UknbyQRHZoaBV0juQUW83lLIoW3JsIPVA0anU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: pgf@laptop.org
Subject: Re: [PATCH] forced recalibration for the OLPC hgpk touchpad
Date: Wed, 3 Jun 2009 08:04:57 -0700
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6; KDE/4.2.3; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3026.1243972079@foxharp.boston.ma.us>
In-Reply-To: <3026.1243972079@foxharp.boston.ma.us>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1782
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906030804.57340.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tuesday 02 June 2009 12:47:59 pgf@laptop.org wrote:
> The OLPC XO laptop incorporates a combination touchpad/tablet
> device which unfortunately requires frequent recalibration.  The
> driver will force this automatically when various suspicious
> behaviors are observed, and the user can recalibrate manually
> (with a special keyboard sequence).  There's currently no way,
> however, for an external program to cause recalibration.
>
> This patch creates a new node in /sys which, when written with '1',
> will force a touchpad recalibration.  No other writes (or reads)
> of this node are supported.
>


Instead of creating a new sysfs attribute maybe we should make
the touchpad recalibrate upon resume (reconnect)? Userspace can
already request reconnect via sysfs.
 
-- 
Dmitry

