Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYAIAZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYAIAZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYAIAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:25:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45899 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYAIAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:25:03 -0500
Date: Wed, 9 Jan 2008 01:27:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com, jgarzik@pobox.com, linux-ide@vger.kernel.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109002729.GH2117@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <47840C57.6000304@gmail.com> <20080109000946.GG2117@one.firstfloor.org> <47841296.8090104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47841296.8090104@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry about the noise here - I now notice that not all .ioctl function
> pointers have the option of changing to .unlocked_ioctl.  In this case,
> the ioctl is in the struct scsi_host_template, rather than struct
> file_operations.
> 
> I'll try to be a little more careful about the git grepping in the future.

Well it just points to another area that needs to be improved. Clearly
scsi_host_template should have a unlocked_ioctl too.

-Andi
