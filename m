Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZICRQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZICRQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZICRQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:16:11 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:50534 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZICRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:16:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nbHDpwSVspeFh9nTNj7c6eBnQ6HJmf/VnhNXySlVzz14a+P/UWBKHhRT+AQDw36+/C
         ndBPRzUQN2pDhUuDy3iadFzmD4R8c7g/ucAOnMfCmVmxVQHc1NV465EW0PI+qVo2cag5
         +SmmqvgEqaUa7AexYsgkk2pvbhKFpZtQ1RfxI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: Dell-laptop is not working without wireless
Date: Thu, 3 Sep 2009 10:15:44 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8; KDE/4.3.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>
References: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net> <20090903153215.E51F8526EA5@mailhub.coreip.homeip.net> <4A9FF1FB.5090507@dell.com>
In-Reply-To: <4A9FF1FB.5090507@dell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <20090903174839.948A4526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 09:42:35 am Mario Limonciello wrote:
> Hi Dmitry:
> 
> Dmitry Torokhov wrote:
> > On Tue, Aug 18, 2009 at 01:10:49PM +0100, Matthew Garrett wrote:
> >   
> >
> > Admittedly I have not spend much time on it but it looks like my box
> > _really_ wants wifi interface to be fully operational before
> > dcsbas_smi_request() starts returning proper data. I wonder if iwl3945's
> > rfkill support interferes somehow here...
> >
> > Maybe Mario (being a Dell guy) has an idea why this might be happening?
> >
> >   
> I'm on 2.6.31-rc8 or so.  I can't actually reproduce this on a d630.  I
> get all of the rfkill devices populated.
> 

Hmm, what is the BIOS version in your box? Also, mine used to have
broadcom-based wifi and I replaced it with iwl3945, would that make
any difference?

Thanks!

-- 
Dmitry
