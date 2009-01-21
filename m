Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZAUDaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZAUDaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZAUDaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:30:04 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:36122 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZAUDaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:30:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AC2OlYTSAx+9ZbtqCNeLs3LgxpCEJj6ryUkBOvd2WQsliI/+T+MHP5vRQQ/PY5VuwZ
         4Hzm2ARklnwC3Gzb3ofRZS3XIJb+hbuFuc3kDI3Mu8EI5r2Wz5iPjyxfGjln7enhhvoC
         /8OkBWfH1z87+WTPucky1qBbDEVEZxAD0qgPA=
From: Ionut Leonte <garglkml@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.28 changes in-kernel name for UVC device ?
Date: Wed, 21 Jan 2009 05:23:01 +0200
User-Agent: KMail/1.9.9
References: <200901201349.33707.ionut.leonte@gmail.com> <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com> <49760649.8000800@s5r6.in-berlin.de>
In-Reply-To: <49760649.8000800@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210523.01282.ionut.leonte@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009 19:13:45 you wrote:
> Kay Sievers wrote:
> > You may just disable the firefire drivers if you don't need them.
>
> It is not even necessary to disable the drivers; it would be sufficient
> to not force-load the video1394 module.  (Or to fix the udev rule.)
> Presence of a Firewire card does not cause video1394 to be auto-loaded;
> only certain types of FireWire cameras cause respective uevents and thus
> autoloading of the special-purpose driver video1394.  Ergo, Ionut's
> userland has a configuration somewhere which loads video1394 explicitly.

It's most likely related to my kernel being monolithic - the only modules I 
have are out-of-tree ones (like the binary nvidia driver and ndiswrapper). 
Perhaps it's time I reconsidered my monolithic aproach to kernel building and 
start compiling stuff as modules again.
