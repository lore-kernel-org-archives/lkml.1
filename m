Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYCNXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYCNXeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYCNXeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:34:08 -0400
Received: from gherkin.frus.com ([192.158.254.49]:41992 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbYCNXeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:34:07 -0400
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: "from (env: rct) at Mar 14, 2008 08:13:44 am"
To: twhitehe@uwo.ca
Date: Fri, 14 Mar 2008 18:33:57 -0500 (CDT)
CC: Rene Herman <rene.herman@keyaccess.nl>, Bob Tracy <rct@frus.com>,
       Michael Cree <mcree@orcon.net.nz>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080314233357.5223BDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rct wrote:
> Rene Herman wrote:
> > Okay, and applying the attached just makes your sound completely dead in the 
> > water?
> > (patch to remove es1888_init from a Miata build omitted)
> 
> I'll try a build with the old OSS "sb" driver, and if that works ok, we
> may be able to do away with es1888_init() on the Miata.  Tyson -- I
> think you have a Miata if I'm remembering correctly: can you confirm
> these observations?

Quick followup: OSS "sb" driver works fine without es1888_init().

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
