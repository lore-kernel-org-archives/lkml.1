Return-Path: <linux-kernel-owner+w=401wt.eu-S1762807AbZCaWEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762807AbZCaWEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZCaWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:04:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35295
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754811AbZCaWEV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:04:21 -0400
Date: Tue, 31 Mar 2009 15:04:09 -0700 (PDT)
Message-Id: <20090331.150409.149323548.davem@davemloft.net>
To: oliver@neukum.org
Cc: Larry.Finger@lwfinger.net, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] kaweth: Fix locking to be SMP-safe
From: David Miller <davem@davemloft.net>
In-Reply-To: <200903312350.38658.oliver@neukum.org>
References: <49d264dd.YwbXLw18YaD1tQqD%Larry.Finger@lwfinger.net>
	<200903312350.38658.oliver@neukum.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>
Date: Tue, 31 Mar 2009 23:50:38 +0200

> Am Dienstag 31 März 2009 20:45:49 schrieb Larry Finger:
> > On an SMP system, the following message is printed. The patch below gets
> > fixes the problem.
> 
> Are you sure it is never called with disabled interrupts?

Please be specific, what is this "it" you are referring to?

Larry's patch modifies the locking many functions, and you didn't
quote the kernel locking error message if that provides the context of
your comment.
