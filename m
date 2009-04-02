Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZDBSgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZDBSgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761350AbZDBSgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:36:35 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2735 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761361AbZDBSgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:36:33 -0400
Date: Thu, 2 Apr 2009 22:36:31 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] QE USB Host Integration for MPC832x
Message-ID: <20090402183631.GA6699@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1238622396-9768-1-git-send-email-marcel@ziswiler.com> <20090402183357.GA29050@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090402183357.GA29050@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:33:57PM +0400, Anton Vorontsov wrote:
[...]
> > +			compatible = "fsl,mpc8360-qe-usb",
> 
> Ditto. No need for mpc8360 compatible.

Oh, I was wrong. fsl_qe_udc driver uses mpc8360 compatible for
matching, so you can't remove it. :-/

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
