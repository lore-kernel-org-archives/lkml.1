Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbZFWLSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbZFWLSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZFWLSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:18:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36851
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbZFWLSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:18:44 -0400
Date: Tue, 23 Jun 2009 04:18:48 -0700 (PDT)
Message-Id: <20090623.041848.43828217.davem@davemloft.net>
To: elendil@planet.nl
Cc: bzolnier@gmail.com, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: Improve "weird block size" error message
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906231313.55057.elendil@planet.nl>
References: <200906230951.24615.elendil@planet.nl>
	<20090623.035926.155211513.davem@davemloft.net>
	<200906231313.55057.elendil@planet.nl>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Tue, 23 Jun 2009 13:13:53 +0200

> But I think my patch still makes sense for those cases where the original 
> error _does_ exist. Unless your patch fixes those as well, but we can't 
> know that for sure, can we?

That's a very good point, so yes it makes sense to add your
change as well.

I'm convinced there exists some case where my patch doesn't "fix"
things.  Jens only would have submitted that patch if there were some
OOPS that he had diagnosed to precisely this problem.
