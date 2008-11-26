Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYKZOmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYKZOmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKZOmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:42:42 -0500
Received: from usul.saidi.cx ([204.11.33.34]:56541 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751995AbYKZOmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:42:42 -0500
Message-ID: <492D604C.10707@overt.org>
Date: Wed, 26 Nov 2008 06:42:20 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx, drzeus@drzeus.cx,
       fseidel@suse.de, weyland@library.ethz.ch,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
References: <492BBA91.5010302@overt.org> <200811261436.57946.elendil@planet.nl>
In-Reply-To: <200811261436.57946.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
>> The latest generation of laptops are shipping with a newer
>> model of Ricoh chip where the firewire controller is the
>> primary PCI function but a cardbus controller is also present.
> 
> Note that the current separate ricoh_mmc disabling module approach has 
> been shown to break during suspend/resume. Matthew Garret proposed a 
> patch for that which (with minor fixups) I tested successfully.

Hmm. Well, I'm interested as to what Pierre thinks. He explicitly didn't
want a quirk when we originally looked at the problem and that's why
ricoh_mmc exists - but maybe this is a good enough reason to revisit that
decision.

--phil
