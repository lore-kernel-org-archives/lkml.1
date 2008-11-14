Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYKNMXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYKNMXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 07:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYKNMXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 07:23:34 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:58354 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbYKNMXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 07:23:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=TO+IxrzB+5jypAaM7ChO9soNVk5n5g0QjyRVZjYoVsWH8Exqt82pnO4FbJV+3Pu9PhSRxzbCg+eGvxgCPK5ijF7BupPes8a2UwdA3HYKzf9ECOGMyvl89rsdLOEwZ27o;
Message-ID: <0cff1148a04c9f90c98e26eff6e0bfc968e4574c@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <491C3813.1070305@movial.fi>
References: <1226585472-12559-1-git-send-email-bwalle@suse.de>
    <b637ec0b0811130618o2f76e34bh17055f2f165d89a5@mail.gmail.com>
    <491C3813.1070305@movial.fi>
Date: Fri, 14 Nov 2008 12:23:22 -0000
Subject: Re: [PATCH] Allow SCSI_WAIT_SCAN to be deselected
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Dmitri Vorobiev" <dmitri.vorobiev@movial.fi>
Cc: "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Bernhard Walle" <bwalle@suse.de>, james.bottomley@steeleye.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, November 13, 2008 14:22, Dmitri Vorobiev wrote:
> Fabio Comolli wrote:
>> So I'm not the only one :-)
>> Please see this thread:
>>
>> http://lkml.org/lkml/2008/10/22/355
>
> See also:
>
> http://marc.info/?l=linux-scsi&m=122538386519971&w=2
> http://marc.info/?l=linux-scsi&m=122539443509753&w=2

I suggest reading http://lkml.org/lkml/2007/5/13/75.

Basically, if you want to get rid of it you need to provide
a viable alternative. (Loading a module is not the right
way to call a kernel function...) Then it could be default
'n' and marked as deprecated.

-- 
Simon Arlott
