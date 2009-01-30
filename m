Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZA3O5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZA3O5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZA3O5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:57:21 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:60323 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZA3O5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=gC8IW7wDAiV+b008lnRrXLQR1el/DycNgcS5IaPLaL7lQAQkUaQ7RubY4P+g5mkdDs
         XP+iPMiZP6ofluVzx9e7UAGHxk5Do1hi8J7QZ3CZ4yeaZbp1hybv3jhr8kMgbd2JJWEr
         UbxAIJHej0wP12JXY6LWZTUZp1pVlgISDqBWI=
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Dai Haruki <dai.haruki@freescale.com>,
       Andy Fleming <afleming@freescale.com>
Subject: Re: [BUG BISECTED] boot hangs while bringing up gianfar ethernet
References: <20090129194145.GA4647@ovro.caltech.edu>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Fri, 30 Jan 2009 15:57:15 +0100
In-Reply-To: <20090129194145.GA4647@ovro.caltech.edu> (Ira Snyder's message of "Thu\, 29 Jan 2009 11\:41\:45 -0800")
Message-ID: <87bpton8ok.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ira" == Ira Snyder <iws@ovro.caltech.edu> writes:

 Ira> Hello,

 Ira> I'm working on a Freescale MPC8349EMDS board. I have been
 Ira> booting it over NFS for a long time now. I try to run the latest
 Ira> git kernels to find possible problems.

 Ira> Recently, I haven't been able to boot over NFS anymore. When the machine
 Ira> tries to bring up the ethernet interface, it just hangs forever. There
 Ira> are no softlockup warnings, the machine has locked up completely.

FYI, I'm seeing the same here (with a mpc8347) with all 2.6.29-rcX,
but I didn't have time to track it down yet.

-- 
Bye, Peter Korsgaard
