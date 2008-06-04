Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYFDOcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYFDOcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYFDOcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:32:39 -0400
Received: from gw.goop.org ([64.81.55.164]:47595 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYFDOcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:32:39 -0400
Message-ID: <4846A75E.40305@goop.org>
Date: Wed, 04 Jun 2008 15:31:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       dhazelton@enter.net, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org> <20080603210048.GA12182@c2.user-mode-linux.org>
In-Reply-To: <20080603210048.GA12182@c2.user-mode-linux.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Tue, Jun 03, 2008 at 01:07:09PM -0700, Andrew Morton wrote:
>   
>> So if I change the host's time by an hour, the time will not advance at all
>> on the guest for the next hour? Sounds suboptimal :)
>>     
>
> It is, but if the host is whacked, the guest just has to do the best that
> it can...
>   

Shouldn't UML use a monotonic host clock for guest timekeeping?

    J
