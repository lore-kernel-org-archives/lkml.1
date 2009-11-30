Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZK3S47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZK3S47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZK3S47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:56:59 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:52452 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZK3S47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:56:59 -0500
Date: Mon, 30 Nov 2009 12:57:02 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Jonathan Miles <jon@cybus.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B1402FC.80307@cybus.co.uk>
Message-ID: <alpine.DEB.2.00.0911301253410.18682@router.home>
References: <4B1402FC.80307@cybus.co.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Jonathan Miles wrote:

> I'm running kernel 2.6.31.

Are you using a 32 bit kernel?

Disabling swap means that the kernel cannot swap out anonymous pages. Thus
the chance of OOMs conditions is increased.

In order to find the reason for the OOM (which has not much to do with
memory, the kernel has been unable to reclaim memmory for some reason)
you need to look at the debug output that the kernel generates.

