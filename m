Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbXLLLXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbXLLLXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbXLLLXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:23:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbXLLLXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:23:46 -0500
Date: Wed, 12 Dec 2007 03:23:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 39/47] Update and improve CRISv32 fasttimer.c
Message-Id: <20071212032343.302d1a4b.akpm@linux-foundation.org>
In-Reply-To: <4ee86e3bbe8494a2162c7d8c0fc0b109b5e37086.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<4ee86e3bbe8494a2162c7d8c0fc0b109b5e37086.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 17:46:11 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

>  arch/cris/arch-v32/kernel/fasttimer.c |  519 ++++++++++++--------------------

I'm suspecting that most of the inlines which this patch retains are
deoptimising the code.

This file still seems to use two-spaces for indentation in many places.
