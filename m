Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYA0V1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYA0V1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYA0V1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:27:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYA0V1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:27:32 -0500
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: vatsa@linux.vnet.ibm.com, Tomasz Chmielewski <mangoo@wpkg.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       dhaval@linux.vnet.ibm.com
In-Reply-To: <200801271757.07743.toralf.foerster@gmx.de>
References: <479B69D2.5050603@wpkg.org>
	 <200801271606.19862.toralf.foerster@gmx.de>
	 <20080127165400.GB1044@linux.vnet.ibm.com>
	 <200801271757.07743.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 Jan 2008 22:27:16 +0100
Message-Id: <1201469236.6149.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 17:57 +0100, Toralf Förster wrote:

> It would be nice to run a grid application at lowest priority without impact to
> power / fan / temperature but OTOH have full performance for desktop
> applications, isn't it ?

This can be achieved by giving the group/uid the grid application uses a
weight of 2.

