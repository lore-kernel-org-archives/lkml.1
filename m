Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYLSIbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYLSIbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYLSIbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:31:11 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40848 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYLSIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:31:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T0QQrH3SAkVX99bU7N+l6JqGaZ9B4ZGKj02IayiJebZKR6wY1w7cimByROP5kMoLqi
         0t5TnEG02+3TMjVqDNJSq13BP45950h0kWg5yOcmoI/xGcGehT2SHq8ts/pMMIJ3ouYJ
         9QhVR0fsoptq8JJJtyxML8a7L4KEJVhIFtN9U=
Message-ID: <494B5BC4.100@gmail.com>
Date: Fri, 19 Dec 2008 09:31:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: Ben Dooks <ben-linux@fluff.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com>	 <20081216155822.GD12431@fluff.org.uk>	 <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>	 <20081216194113.GF12431@fluff.org.uk> <154e089b0812161144x3c9579f5g8731b616fde6484c@mail.gmail.com>
In-Reply-To: <154e089b0812161144x3c9579f5g8731b616fde6484c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2008 08:44 PM, Hannes Eder wrote:
> But, don't ask my why the void functions with empty function bodies
> are exported.

Because of autoload to create a dependency. Note that this is a temporary
solution to workaround the non-presence of hid bus in module-init-tools and will
be removed in next few releases.
