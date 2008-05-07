Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYEGNGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYEGNGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 09:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYEGNGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 09:06:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15509 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYEGNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 09:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HMsnuAHiT+0zDmA1nYumLfR3g+SmBrXQnTAORKRYqwKpSh663/ixenUSl2l8LQ219jyrtYAuD/VybnNkOhwYtS/ItUjd//XXbgHvc0vgiLQFW7KyHRZSdoeM59irLApb1o3m8zwsWBihr0xM2ReIo7tRY6+cigbs4tMXRLsVD5c=
Message-ID: <e2e108260805070606n1d05af0dob521a17adf2a6e9f@mail.gmail.com>
Date: Wed, 7 May 2008 15:06:02 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Martin Knoblauch" <spamtrap@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br
In-Reply-To: <177578.8968.qm@web32608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <177578.8968.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 2:42 PM, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
>
>  any news on the one below? I upgraded to 2.6.25.2 and the problem still persists. Would adding a bugzilla actually help ? :-)
>
> http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/1144.html

I noticed a similar issue on 2.6.22 and 2.6.24 kernels: with ACPI
disabled Linux' clock jumps backward and forward early during boot.
See also the kernel messages from the attachment in comment #13 of
http://bugzilla.kernel.org/show_bug.cgi?id=9936.

Bart,
