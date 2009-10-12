Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZJLSfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZJLSfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbZJLSfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:35:36 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.43]:47563 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbZJLSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:35:36 -0400
Message-ID: <4AD376B9.7040404@bwalle.de>
Date: Mon, 12 Oct 2009 20:34:33 +0200
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Andi Kleen <andi@firstfloor.org>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>	<1255207870-24496-6-git-send-email-bernhard@bwalle.de>	<87d44sh5uj.fsf@basil.nowhere.org>	<4AD37478.2070204@bwalle.de> <20091012113055.13d3b7e3@jbarnes-g45>
In-Reply-To: <20091012113055.13d3b7e3@jbarnes-g45>
X-Enigmail-Version: 0.95.7
OpenPGP: id=DDAF6454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes schrieb:
> 
> It's called in the panic notifier atm.  Yeah sounds like kexec vs
> notifiers should be reordered a bit (or the current panic notifier
> should be split into notify and "yes we actually failed to do anything"
> cases).

Well, we had that discussion several times. But maybe the opinion of
some developers changed because now there would be an in-kernel user of
notification before kexec.


Regards,
Bernhard

