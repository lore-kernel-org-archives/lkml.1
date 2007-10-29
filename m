Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXJ2P6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXJ2P6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXJ2P55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:57:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:7291 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbXJ2P54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=hFeRjnJ30vqqyVtp9TIyk5ge/ACy1ZakxQDAT3R8EBPAyz3/ShBiYllQ+RdUuNBnqtJ/CJpyAC9eQYEv+90+eIATAKmOZOBcJ1qHJI3gNTfLyuLwqURGBp8k+IIooy24xIwOmHIwkSsVbCdebacRwKkyhZM087j5Opq750Ygaxw=
Message-ID: <472602E6.4080902@googlemail.com>
Date: Mon, 29 Oct 2007 16:57:26 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: lkml <linux-kernel@vger.kernel.org>, Luca Bigliardi <shammash@artha.org>,
       Jeff Dike <jdike@linux.intel.com>
Subject: Re: build failure, missing libvdeplug.h?
References: <4725FB46.70802@tiscali.nl> <4725FF15.5050908@tiscali.nl>
In-Reply-To: <4725FF15.5050908@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:

[ added some peoples to Cc ]

> Roel Kluin wrote:
>> the file libvdeplug.h is missing
> 
>> There is a reference to http://wiki.virtualsquare.org/index.php/Main_Page in
>> the Kconfig (also added by this commit).
>> After reverting this commit the build continues. possibly the header 
>> libvdeplug.h was forgotten?
> 
> Sorry for answering myself, but apparently it can be found here:
> 
> http://vde.sourceforge.net/
> 
> I think, however that there is a 'depends on' missing in kconfig - to prevent build
> failure?

