Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYJ2NVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYJ2NVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYJ2NVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:21:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:9976 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYJ2NVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VHnpoRZUtatdWTjilPEcs/fPcKXVj5m8XGuLatXrG3LO6Cr0DJYvNUhrPog85ATano
         Dn0NnzuKcc1iUEGVtoY88sb8eTeT2+Cn5jFkUEbuEdaJdxAvPgTteMqJAYMHRRYNHEvk
         MAxPo5hqCF1BoWZD9giEUyJZFGS+Heu9bYKZ4=
Message-ID: <f870da180810290621m38310d8exdfb8a69f32c1fd3c@mail.gmail.com>
Date: Wed, 29 Oct 2008 15:21:02 +0200
From: "Mike Rapoport" <mike.rapoport@gmail.com>
To: "Jonathan Cameron" <Jonathan.Cameron@gmail.com>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support go?
Cc: "Liam Girdwood" <lrg@kernel.org>, felipe.balbi@nokia.com,
       "ext Jonathan Cameron" <jic23@cam.ac.uk>,
       "eric miao" <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Mark Brown" <broonie@sirena.org.uk>
In-Reply-To: <4908547C.4090907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4906F500.7080100@cam.ac.uk>
	 <20081028112341.GF27144@gandalf.research.nokia.com>
	 <1225195382.28382.168.camel@dell-desktop.example.com>
	 <4908547C.4090907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 2:18 PM, Jonathan Cameron
<Jonathan.Cameron@gmail.com> wrote:

> Battery Charger.
>    This one is complex.  Supports 40 to 1400mA and 4 to 4.35V supply
>    with lots of monitoring.  Has several different operating modes
>    and needs a non trivial driver.  This one will be 'interesting'
>    to write (have a sand bucket ready and cross your fingers)

I have the battery charger driver for EM-X270, but for now it's
tightly coupled to the platform code.
I'll try to make it generic but it'll take some time...




-- 
	Sincerely Yours,
		Mike.
