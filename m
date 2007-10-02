Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbXJBLei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbXJBLei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbXJBLeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:34:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbXJBLea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:34:30 -0400
Date: Tue, 2 Oct 2007 13:34:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Giuliano Gagliardi <gogi-k@gogi.tv>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: One process with multiple user ids.
In-Reply-To: <200710021333.05826.gogi-k@gogi.tv>
Message-ID: <Pine.LNX.4.64.0710021334130.7130@fbirervta.pbzchgretzou.qr>
References: <200710021256.08469.gogi-k@gogi.tv>
 <Pine.LNX.4.64.0710021322110.7130@fbirervta.pbzchgretzou.qr>
 <200710021333.05826.gogi-k@gogi.tv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2 2007 13:33, Giuliano Gagliardi wrote:

>Date: Tue, 2 Oct 2007 13:33:05 +0200
>From: Giuliano Gagliardi <gogi-k@gogi.tv>
>To: Jan Engelhardt <jengelh@computergmbh.de>
>Subject: Re: One process with multiple user ids.
>
>On Tuesday 02 October 2007, Jan Engelhardt wrote:
>> On Oct 2 2007 12:56, Giuliano Gagliardi wrote:
>> >I have a server that has to switch to different user ids, but because it
>> > does other complex things, I would rather not have it run as root. I only
>> > need the server to be able to switch to certain pre-defined user ids.
>>
>> All you need is CAP_SETUID. Also see man setresuid,
>> where you could, I think, use saved_uid=0 if you do not
>> like to use real_uid=0 effective_uid=non-0.
>
>But CAP_SETUID would let me change to any uid, would it not? I would like my 
>process to have no possibility to change to any uid, except some predefined 
>set, so that in case of a security hole only those uids could be compromised.
>
>

You could write up a LSM that restricts UID changing.

