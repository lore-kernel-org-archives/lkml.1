Return-Path: <linux-kernel-owner+w=401wt.eu-S933887AbZJMPyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbZJMPyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760453AbZJMPyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:54:44 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:58243 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447AbZJMPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a7nIc853SNH90UTeljbNr/r+IcDrVvVLE3hmHl7jCy5iM2nS+zjKn7LqvCech0C4Az
         HyRQjJDxk1bZ+wjsP/jg6E2zeFcODwZjQE/w9D/IwlDfctIe/VgxIIcka2xkm8044fjj
         dZsUJHptQlNQQ91GBEfqti0zOnJoIij2k8wUE=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 17:52:52 +0200
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr>
In-Reply-To: <4AD46380.9020308@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910131752.52589.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
> In 2.6.31, there are USB device IDs common between both drivers.

That is because they are drivers for the same hardware.

> Should  a distribution enable both drivers? What do you suggest? Are there any
> *known issues* stuff for one of them?

The staging/rt2870 should actually be removed from the kernel tree,
I am going to merge rt2800pci soon as well and after that I'll send a patch
to remove all Ralink drivers from the staging tree.

As for known issues:
- staging/rt2870 is a piece of crap which apparently works for some people
but isn't generally stable or reliable
- wireless/rt2800usb follows the kernel coding style/rules and uses mac80211
but isn't showing a high quality for usability.

Ivo
