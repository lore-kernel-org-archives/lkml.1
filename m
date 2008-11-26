Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYKZOyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYKZOyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYKZOyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:54:14 -0500
Received: from usul.saidi.cx ([204.11.33.34]:36304 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753847AbYKZOyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:54:13 -0500
Message-ID: <492D6300.2060401@overt.org>
Date: Wed, 26 Nov 2008 06:53:52 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx, drzeus@drzeus.cx, fseidel@suse.de,
       weyland@library.ethz.ch
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
References: <492BBA91.5010302@overt.org> <200811261436.57946.elendil@planet.nl> <492D604C.10707@overt.org> <20081126145039.GA31043@srcf.ucam.org>
In-Reply-To: <20081126145039.GA31043@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> 
> Thinking about it, it could possibly be handled by changing to 
> suspend_noirq and resume_noirq rather than the normal suspend and resume 
> functions? That ought to get the ordering constraints right. The problem 
> occurs when ricoh_mmc suspends before sdhci and resumes after it.

I'll investigate that and see what happens.

--phil
