Return-Path: <linux-kernel-owner+w=401wt.eu-S1759570AbYGaV7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570AbYGaV7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbYGaV6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:58:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:38612 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758964AbYGaV6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:58:24 -0400
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <DAE7C7B4-CE5B-45EB-B3B4-E5491A843CD9@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20080731210410.GA623@polina.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: libata badness
Date: Thu, 31 Jul 2008 16:58:05 -0500
References: <95646AC3-5385-4F59-8EBA-20F811168A87@kernel.crashing.org> <20080731210410.GA623@polina.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I figured out the issue.  Its related to the interrupt routing being  
conveyed to the code from the device tree.  We have a missing 'space'  
causing issues.

- k
