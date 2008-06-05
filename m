Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYFEKVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYFEKVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYFEKV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:21:29 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:2707 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYFEKV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:21:29 -0400
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 06:21:29 EDT
From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Organization: SelfOrganizing
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
Date: Thu, 5 Jun 2008 12:07:50 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080605.foo@pmac.infradead.org>
In-Reply-To: <20080605.foo@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806051207.50556.arekm@pld-linux.org>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008, David Woodhouse wrote:
> Ignoring the set of 'make fw->data const' patches which have mostly
> been already posted and are fairly trivial, this is the current content
> of the firmware tree at git.infradead.org/users/dwmw2/firmware-2.6.git
>
> It starts by giving a way to build arbitrary firmware blobs into the
> kernel while letting request_firmware() find them there, and then sets
> about converting drivers to use request_firmware() instead of static
> data blobs, now that we can do that without forcing the users to
> actually  satisfy the firmware requests from userspace.

Will there be a way for userspace to know what firmware file is needed by 
which driver? 

So for example geninitrd/mkinitrd will be able to put only required firmware 
files into initrd/initramfs (without a need to maintain separate database 
with driver <-> firmware file name mapping).

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
