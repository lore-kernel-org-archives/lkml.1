Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZGPLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZGPLkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZGPLkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:40:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38593 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286AbZGPLkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:40:23 -0400
X-Sasl-enc: f+gVRMgF+PjFI64WvdPTGpbN7yStnz2Pyy6YBuvYMW6u 1247744423
Date: Thu, 16 Jul 2009 08:40:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       arjan@linux.intel.com, "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 0/8] device async action mechanism
Message-ID: <20090716114020.GA11928@khazad-dum.debian.net>
References: <1247643512.26272.74.camel@rzhang-dt>
 <87ocrm6xeq.fsf@basil.nowhere.org>
 <1247710483.26272.170.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247710483.26272.170.camel@rzhang-dt>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Zhang Rui wrote:
> the kernel device suspend time is reduced from 3.2s to 2.8s after
> applying this patch set in my test box.

It will give even a bigger boot time saving on ThinkPads, where there is a
Synaptics (or ALPS if you are unlucky) touchpad with the trackpoint behind
it... it takes about 2s to init both devices here.  That's two seconds of
boot time you can shove off if it is being initialized assyncronously :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
