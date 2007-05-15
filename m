Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbXEONtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbXEONtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 09:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXEONtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 09:49:05 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:47989 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbXEONtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 09:49:04 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200705151348.l4FDmlD7001813@clem.clem-digital.net>
Subject: Re: 2.6.22-rc1 lost snd_4236 device
To: tiwai@suse.de (Takashi Iwai)
Date: Tue, 15 May 2007 09:48:47 -0400 (EDT)
Cc: rene.herman@gmail.com (Rene Herman),
       clem@clem.clem-digital.net (Pete Clements),
       linux-kernel@vger.kernel.org (linux-kernel),
       alsa-devel@alsa-project.org (ALSA devel)
In-Reply-To: <s5hy7jqgymj.wl%tiwai@suse.de>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Takashi Iwai
  > At Tue, 15 May 2007 07:42:41 +0200,
  > Rene Herman wrote:
  > > 
  > > [1  <text/plain; ISO-8859-15 (7bit)>]
  > > On 05/13/2007 06:23 PM, Pete Clements wrote:
  > > 
  > > > Fyi:
  > > > With 2.6.22-rc1 get following when loading sound device module. Introduced
  > > > with 2.6.21-git16.
  > > > 
  > > > FATAL: Error inserting snd_cs4236 (/lib/modules/2.6.22-rc1/kernel/sound/isa/cs423x/snd-cs4236.ko): No such device
  > > > FATAL: Error running install command for snd_cs4236
  > > 
  > > Yup; the conversion of the mixed legacy/pnp ALSA drivers to the isa_bus 
  > > framework is not quite right. Wants the attached.
  > 
  > Grr, forgot about the error return at probe.
  > 
  > > Takashi, this needs to go to Linus. Can you make sure it gets there? This is 
  > > against -linus HEAD.
  > > 
  > > Signed-off-by: Rene Herman <rene.herman@gmail.com>
  > 
  > Thanks.  I applied it to ALSA tree so that it will be queued in the
  > next push round.
  > 
  > 
  > Takashi
  > -

Applied patch. Module loads.

-- 
Pete Clements 
