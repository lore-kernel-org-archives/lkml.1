Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYAXU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYAXU0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYAXU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:26:26 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:6077 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYAXU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:26:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ltYSHPaXCIMJ2+MP9egFohW3d6fx8Xk4zyFFjy7iwHQbqRdjQwLmWe04QUaF4PIeyFcvCBZ0/5KSBgLMR65IMbOldrnxHrHf6AAY1nwp6m5ezdxfljr7ahIf/lLYP28tQiBJ6j/ak4cARunZFpw1DvBbT/JjpVorJpIum8K2AfA=
Message-ID: <84144f020801241226o6cf712c1vf2cd5ae08c7b49ba@mail.gmail.com>
Date: Thu, 24 Jan 2008 22:26:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Greg KH" <greg@kroah.com>, "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801242100.22090.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <84144f020801240942y1c75c82geddc250b7e7814ac@mail.gmail.com>
	 <20080124180313.GA16006@kroah.com>
	 <200801242100.22090.oliver@neukum.org>
X-Google-Sender-Auth: df078763d717fca6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 24, 2008 10:00 PM, Oliver Neukum <oliver@neukum.org> wrote:
> A discussion about lifetime rules for objects in sysfs anyone? ;->

Furthermore, you need to unmount all devices before you can unplug one of them.
