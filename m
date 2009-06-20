Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZFTEm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZFTEm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 00:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFTEms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 00:42:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:8387 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZFTEms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 00:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XplE+0+eXnSMax7kaFxvb5iam7oAp0hbc0SlQNQUU5Ufe6HtWs4RXa1H0y0Mm7nl7/
         wcxqYvJX+DU+qKaI6PBEXg32r09Y49kGaze6uRfr233EpwYhPAE3LuyHcCmXZv+3Pr5I
         wPMGX/1ojtlgHQn3tPyFfi3Kge4IjghqA9Gfs=
Message-ID: <4A3C68E2.7000508@gmail.com>
Date: Fri, 19 Jun 2009 22:43:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: ronis@ronispc.chem.mcgill.ca
CC: linux-kernel@vger.kernel.org
Subject: Re: Panic booting 2.6.30
References: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
In-Reply-To: <1245439404.25076.7.camel@ronispc.chem.mcgill.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2009 01:23 PM, David Ronis wrote:
> I've just upgraded an older machine (a P3 running slackware 11.0) from
> 2.6.26.5 to 2.6.30; the build was uneventful.  However, on reboot (using
> lilo) I get:
>
> VSF:  Cannot open root device "hda2" or unknown-block(0,0)
> Please append a correct root= boot option; here are the available
> partions:<====== nothing shows here...
> Kernel-Panic - not syncing.
>
> I had rebooted with and without root=hda2.   The old kernel is still
> usable.

Make sure you configured in the proper IDE driver for your chipset. 
Previously I believe the IDE driver would attach to unknown chipsets in 
a crappy generic fashion, but I don't think it does anymore.

If that doesn't help, please post your kernel config and lspci output.
