Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYLECGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYLECGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYLECFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:05:55 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57395 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbYLECFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:05:54 -0500
X-Sasl-enc: nXWLEpyNpy43N/VBvYfNRHUfLhAJnmfInnCSSgbekPYB 1228442752
Date: Fri, 5 Dec 2008 00:05:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: none <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt_Domsch@dell.com, greg@kroah.com, linux-acpi@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2 update] misc: Add dell-laptop driver
Message-ID: <20081205020547.GA4365@khazad-dum.debian.net>
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202201645.GB31620@srcf.ucam.org> <49368329.19e7300a.0526.5a68@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49368329.19e7300a.0526.5a68@mx.google.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I feel weird replying to "none" :-) )

On Wed, 03 Dec 2008, none wrote:
> > +		wifi_rfkill->get_state = dell_wifi_get;
> 
> The rfkill doc (and code) say that you also need to initialize
> wifi_rfkill->state to the current state of the hardware.

I may have screwed up and ommited from the docs the fact that it is not
strictly necessary to do so if you provide rfkill->get_state.  So that is
not a serious problem with the patch at all.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
