Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYENUjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYENUjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYENUi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:38:56 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56754 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYENUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:38:55 -0400
Message-ID: <482B4E4A.3000700@keyaccess.nl>
Date: Wed, 14 May 2008 22:40:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Wolfgang.Erig@gmx.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: 2.6.26-rc1 sound regression
References: <20080514130742.GA28872@erig.dyndns.org>
In-Reply-To: <20080514130742.GA28872@erig.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-08 15:07, Wolfgang Erig wrote:

> my sound stops working with 2.6.26-rc1,

Thanks for the report and investigation -- this bug has been fixed in 
current mainline (a little post -rc2) already though.

It's commit 4a367f3a9dbf2e7ffcee4702203479809236ee6e, "x86/PCI: fix 
broken ISA DMA"

Rene.
